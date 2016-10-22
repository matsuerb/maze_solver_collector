require 'test_helper'

class SolversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solver = solvers(:one)
  end

  test "should get index" do
    get solvers_url
    assert_response :success
  end

  test "should get new" do
    get new_solver_url
    assert_response :success
  end

  test "should create solver" do
    assert_difference('Solver.count') do
      post solvers_url, params: { solver: { content: @solver.content, elapsed_usec: @solver.elapsed_usec, email: @solver.email, nbytes: @solver.nbytes, username: @solver.username } }
    end

    assert_redirected_to solver_url(Solver.last)
  end

  test "should show solver" do
    get solver_url(@solver)
    assert_response :success
  end

  test "should get edit" do
    get edit_solver_url(@solver)
    assert_response :success
  end

  test "should update solver" do
    patch solver_url(@solver), params: { solver: { content: @solver.content, elapsed_usec: @solver.elapsed_usec, email: @solver.email, nbytes: @solver.nbytes, username: @solver.username } }
    assert_redirected_to solver_url(@solver)
  end

  test "should destroy solver" do
    assert_difference('Solver.count', -1) do
      delete solver_url(@solver)
    end

    assert_redirected_to solvers_url
  end
end
