require "open3"
require "tempfile"

class Solver < ApplicationRecord
  def content=(s)
    super
    self.nbytes = s.bytesize
  end

  def run_and_set_result
    # TODO: 問題と答えを複数渡せるようにする
    expected = <<EOS
###########
S:#:::::# #
#:#:###:# #
#:::#:::# #
#####:### #
#:::::#   #
#:### # ###
#:::# # # #
###:### # #
#  :::::::G
###########
EOS
    problem = expected.gsub(":", " ")
    time_result_path = "/time.txt" # TODO: 毎回変更する．

    docker_create_command = %W[
      docker create -i --net none --cpuset-cpus 0 --memory 512m
      --memory-swap 512m --ulimit nproc=10:10 --ulimit fsize=1000000
      -w /workspace solver_runner
        /usr/bin/time -q -f %e -o #{time_result_path}
          timeout 3 su nobody -s /bin/bash -c
    ] + ["ruby /main.rb"]
    stdout, status = *Open3.capture2(*docker_create_command)
    if !status.success?
      raise "docker createに失敗"
    end
    container_id = stdout[0, 12]
    begin
      Tempfile.create("solver") do |f|
        f.write(content)
        f.close
        File.chmod(0755, f.path)
        run_command("main.rbのdocker cpに失敗",
                    "docker cp #{f.path} #{container_id}:/main.rb")
      end

      docker_start_command = %W[docker start -i #{container_id}]
      stdout, status = *Open3.capture2(*docker_start_command,
                                       stdin_data: problem)
      if !status.success?
        raise "docker startに失敗: command=#{docker_start_command.inspect}"
      end
      begin
        if expected != stdout
          self.elapsed_usec = -1
          return
        end

        time_result = Tempfile.create("solver") { |f|
          f.close
          run_command("#{time_result_path}のdocker cpに失敗",
                      "docker cp " +
                      "#{container_id}:#{time_result_path} #{f.path}")
          File.read(f.path)
        }
        self.elapsed_usec = (time_result.to_f * 1_000_000).round
      ensure
        run_command("docker stopに失敗", "docker stop #{container_id}")
      end
    ensure
      run_command("docker rmに失敗", "docker rm #{container_id}")
    end
  end

  private

  def run_command(error_message, *command)
    if !system(*command)
      raise "#{error_message}: command=#{command.inspect}"
    end
  end
end
