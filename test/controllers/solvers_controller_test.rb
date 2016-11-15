require 'test_helper'

class SolversControllerTest < ActionDispatch::IntegrationTest
  # TODO: #indexはランキング表示に使用予定。今は使用しないのでコメントアウトしておく。
  # test("#index") do
  #   get(solvers_url)
  #   assert_response(:success)
  # end

  test("#new") do
    get(new_solver_url)
    assert_response(:success)
  end

  test("#create") do
    assert_difference('Solver.count') do
      post(solvers_url,
           params: {
             solver: attributes_for(:valid_solver).slice(:username, :email,
                                                         :content)
           })
    end

    assert_redirected_to(solver_url(Solver.last))
  end

  test("#show") do
    solver = create(:valid_solver)
    get(solver_url(solver))
    assert_response(:success)
  end
end
