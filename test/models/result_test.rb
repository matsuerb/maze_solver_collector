require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  sub_test_case("#success?") do
    setup do
      create(:maze)
    end

    test("成功時はtrue") do
      solver = create(:valid_solver)
      assert_equal([true], solver.results.map(&:success?))
    end

    test("失敗時はfalse") do
      solver = create(:invalid_solver)
      assert_equal([false], solver.results.map(&:success?))
    end
  end

  sub_test_case("#elapsed_sec") do
    test("処理時間を秒数で返す") do
      result = Result.new(elapsed_usec: 1)
      assert_equal(0.000_001, result.elapsed_sec)
    end
  end
end
