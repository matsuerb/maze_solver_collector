require "open3"
require "tempfile"

class Solver < ApplicationRecord
  has_many :results
  has_many :mazes, through: :results

  validates :email, email_format: {message: 'メールアドレスが正しくありません。'}

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
    Maze.find_each do |maze|
      create_runner_container do |container_id|
        deploy_solver_script(container_id)
        start_solver_script(container_id, maze.question) do |script_result|
          if maze.correct_answer == script_result
            elapsed_usec = parse_time_result(container_id)
          else
            elapsed_usec = -1
          end
          results.build(maze: maze, elapsed_usec: elapsed_usec)
        end
      end
    end
  end

  private

  def time_result_path
    return "/time.txt" # TODO: オブジェクトごとに変更する．
  end

  def run_command(error_message, *command)
    if !system(*command)
      raise "#{error_message}: command=#{command.inspect}"
    end
  end

  def create_runner_container(*args)
    command = %W[
      docker create -i --net none --cpuset-cpus 0 --memory 512m
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
    yield(container_id)
  ensure
    if container_id
      run_command("docker stopに失敗", "docker stop #{container_id}")
    end
  end

  def deploy_solver_script(container_id)
    Tempfile.create("solver") do |f|
      f.write(content)
      f.close
      File.chmod(0755, f.path)
      run_command("main.rbのdocker cpに失敗",
                  "docker cp #{f.path} #{container_id}:/main.rb")
    end
  end

  def start_solver_script(container_id, problem)
    command = %W[docker start -i #{container_id}]
    stdout, status = *Open3.capture2(*command, stdin_data: problem)
    if !status.success?
      raise "docker startに失敗: command=#{command.inspect}"
    end
    begin
      yield(stdout)
    ensure
      run_command("docker stopに失敗", "docker stop #{container_id}")
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
end
