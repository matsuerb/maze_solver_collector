require 'test_helper'

class SolverTest < ActiveSupport::TestCase
  setup do
    create(:maze)
  end

  sub_test_case("#run_and_set_result") do
    test("想定通りの答えならelapsed_usecが正の整数") do
      solver = build(:valid_solver)
      solver.run_and_set_result
      solver.save!
      assert_operator(0, :<, solver.elapsed_usec)
    end

    test("末尾の改行の有無によらず正解") do
      solver = build(:valid_solver)
      solver.content += "\nputs\n"
      solver.run_and_set_result
      solver.save!
      assert_operator(0, :<, solver.elapsed_usec)
    end

    test("答えが間違っているならelapsed_usecが-1") do
      solver = build(:invalid_solver)
      solver.run_and_set_result
      solver.save!
      assert_equal(-1, solver.elapsed_usec)
    end

    test("例外が発生してもelapsed_usecが-1") do
      solver = build(:invalid_solver, content: <<EOS)
raise
EOS
      solver.run_and_set_result
      solver.save!
      assert_equal(-1, solver.elapsed_usec)
    end

    test("標準出力に1MB未満出力するとelapsed_usecが正の整数") do
      solver = build(:valid_solver)
      solver.content = solver.content +
        %Q'print ("\n" * (#{1.megabytes} - 132 - 1))'
      solver.run_and_set_result
      solver.save!
      assert_operator(0, :<, solver.elapsed_usec)
    end

    test("標準出力に1MB以上出力するとelapsed_usecが-1") do
      solver = build(:valid_solver)
      solver.content = solver.content +
        %Q'print ("\n" * (#{1.megabytes} - 132))'
      solver.run_and_set_result
      solver.save!
      assert_equal(-1, solver.elapsed_usec)
    end

    def self.omit_feature_test(name, code_template)
      test_sec = 10
      code = code_template.gsub("%{sec}", test_sec.to_s)
      test(name) do
        solver = build(:valid_solver, content: code)
        start_time = Time.now
        solver.run_and_set_result
        end_time = Time.now
        assert_operator(test_sec, :>, end_time - start_time)
      end
    end

    omit_feature_test("Kernel#sleepは効かない", <<EOS)
sleep(%{sec})
EOS

    omit_feature_test("/bin/sleepは効かない", <<EOS)
system("sleep %{sec}")
EOS

    omit_feature_test("Perlは実行できない", <<EOS)
system("perl", "-e", "sleep(%{sec});")
EOS

    omit_feature_test("Pythonは実行できない", <<EOS)
system("python", "-c", "import time; time.sleep(%{sec});")
EOS
  end

  sub_test_case("#done?") do
    test("処理が完了していればtrue（成功時）") do
      solver = create(:valid_solver)
      assert_equal(true, solver.done?)
    end

    test("処理が完了していればtrue（失敗時）") do
      solver = create(:invalid_solver)
      assert_equal(true, solver.done?)
    end

    test("処理が完了していなければfalse") do
      solver = build(:valid_solver)
      solver.save!
      assert_equal(false, solver.done?)
    end
  end
end
