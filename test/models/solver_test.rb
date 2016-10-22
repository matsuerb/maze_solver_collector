require 'test_helper'

class SolverTest < ActiveSupport::TestCase
  sub_test_case("#run_and_set_result") do
    test("想定通りの答えならelapsed_usecが正の整数") do
      solver = build(:valid_solver)
      solver.run_and_set_result
      assert_operator(0, :<, solver.elapsed_usec)
    end

    test("答えが間違っているならelapsed_usecが-1") do
      solver = build(:invalid_solver)
      solver.run_and_set_result
      assert_equal(-1, solver.elapsed_usec)
    end
  end
end
