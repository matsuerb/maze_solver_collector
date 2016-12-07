require "open3"
require "tempfile"
require "digest/md5"

class Solver < ApplicationRecord
  has_many :results
  has_many :mazes, through: :results

  validates :email, email_format: {message: 'メールアドレスが正しくありません。'}
  validates :nbytes, inclusion: { in: 0..Settings.max_program_size, message: '1MB以上のプログラムは投稿できません。' }
  validates :content, presence: {message: "プログラムが入力されていません。"}

  DivisionVal={
      general: 0, # 一般
      student: 1, # 学生
  }

  scope :ranking_scope, -> (status_value) do
    where(division: status_value).find_each.lazy.select(&:done?).sort_by { |solver|
      [
          -solver.results.correct_answers.count,
          solver.results.correct_answers.sum(:elapsed_usec),
          solver.nbytes,
          solver.created_at,
      ]
    }.uniq(&:email)
  end

  def done?
    return !success? || results.count >= Maze.count
  end

  def success?
    return results.where("elapsed_usec < 0").count.zero?
  end

  def elapsed_usec
    if !success?
      return -1
    end
    return results.sum(:elapsed_usec)
  end

  def content=(s)
    super
    self.nbytes = s.bytesize
  end

  def run_and_set_result
    each_maze do |maze|
      logger.debug("running maze runner.")
      create_runner_container do |container_id|
        logger.debug("created runner container.")
        deploy_solver_script(container_id)
        logger.debug("deployed solver script.")
        begin
          start_solver_script(container_id, maze.question) do |script_result|
            logger.debug("start solver.")
            if rm_tail_linefeed(maze.correct_answer) == rm_tail_linefeed(script_result)
              elapsed_usec = parse_time_result(container_id)
              logger.debug("success: #{{elapsed_usec: elapsed_usec}.inspect}")
            else
              elapsed_usec = -1
              logger.debug("failure.")
            end
            results.build(maze: maze, elapsed_usec: elapsed_usec)
          end
        rescue
          results.build(maze: maze, elapsed_usec: -1)
        end
        logger.debug("stop solver.")
      end
      logger.debug("ran maze runner.")
    end
  end

  def run_and_save_result
    run_and_set_result
    save!
  end

  private

  def time_result_path
    return "/time.txt." + Digest::MD5.hexdigest(object_id.to_s)
  end

  def each_maze
    logger.tagged("solver:#{id}") do
      Maze.find_each do |maze|
        logger.tagged("maze:#{maze.id}") do
          yield(maze)
        end
      end
    end
  end

  def run_command(error_message, *command)
    if !system(*command)
      raise "#{error_message}: command=#{command.inspect}"
    end
  end

  def create_runner_container(*args)
    command = %W[
      docker create -i --net none --cpuset-cpus #{Settings.cpuset_cpus} --memory 512m
      --memory-swap 512m --ulimit nproc=10:10 --ulimit fsize=1000000
      -w /workspace solver_runner
        /usr/bin/time -q -f %e -o #{time_result_path}
          timeout 3 su nobody -s /bin/bash -c
    ] + ["ruby /main.rb"]
    stdout, status = *Open3.capture2(*command)
    if !status.success?
      raise "docker createに失敗 command=#{command.inspect}"
    end
    container_id = stdout[0, 12]
    logger.tagged("container:#{container_id}") do
      yield(container_id)
    end
  ensure
    begin
      run_command("docker rmに失敗", "docker rm #{container_id}")
    rescue => e
      logger.error("failure: #{e.message}")
    end
  end

  def deploy_solver_script(container_id)
    Tempfile.create("solver") do |f|
      f.write(<<EOS)
def sleep(n)
  return n
end
EOS
      f.write(content)
      f.close
      File.chmod(0755, f.path)
      run_command("main.rbのdocker cpに失敗",
                  "docker cp #{f.path} #{container_id}:/main.rb")
    end
  end

  # similar to Open3.capture2 with read limit.
  def capture2(*cmd, stdin_data:)
    Open3.popen2(*cmd) do |i, o, t|
      out_reader = Thread.new {
        o.read(Settings.max_output_size)
      }
      begin
        i.write(stdin_data)
      rescue Errno::EPIPE
      end
      i.close

      out = out_reader.value
      if out && Settings.max_output_size <= out.length
        out = ""
        o.close
      end
      return [out, t.value]
    end
  end

  def start_solver_script(container_id, problem)
    command = %W[docker start -i #{container_id}]
    stdout, status = *capture2(*command, stdin_data: problem)
    if !status.success?
      raise "docker startに失敗: command=#{command.inspect}"
    end
    begin
      yield(stdout)
    ensure
      begin
        run_command("docker stopに失敗", "docker stop #{container_id}")
      rescue => e
        logger.error("failure: #{e.message}")
      end
    end
  end

  def parse_time_result(container_id)
    Tempfile.create("solver") do |f|
      f.close
      run_command("#{time_result_path}のdocker cpに失敗",
                      "docker cp " +
                      "#{container_id}:#{time_result_path} #{f.path}")
      s = File.read(f.path)
      return (s.to_f * 1_000_000).round
    end
  end

  def rm_tail_linefeed(s)
    s.gsub(/((\r)?\n)*\z/m, "")
  end
end
