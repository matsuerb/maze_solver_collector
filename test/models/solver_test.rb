require 'test_helper'

class SolverTest < ActiveSupport::TestCase
  sub_test_case("#run_and_set_result") do
    setup do
      create(:maze)
    end

    test("想定通りの答えならelapsed_usecが正の整数") do
      solver = build(:valid_solver)
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

    test("Kernel#sleepは効かない") do
      solver = build(:valid_solver, content: <<EOS)
sleep(10)
EOS
      start_time = Time.now
      solver.run_and_set_result
      end_time = Time.now
      assert_operator(10, :>, end_time - start_time)
    end
  end
end
