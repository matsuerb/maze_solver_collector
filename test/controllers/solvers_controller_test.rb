require 'test_helper'

class SolversControllerTest < ActionDispatch::IntegrationTest
  def assigns(name)
    # I cannot use ActionPack `assigns` method.
    # So this method is ad-hoc fixes.
    variable_name = :"@#{name}"
    return @controller.instance_variable_get(variable_name)
  end

  def create_solver(name, elapsed_usec, nbytes_offset: 0, email: nil, created_at: nil)
    @maze ||= create(:maze)
    solver = build(:valid_solver, username: name.to_s)
    solver.email = email if email
    solver.created_at = created_at if created_at
    solver.nbytes += nbytes_offset
    solver.results.build(elapsed_usec: elapsed_usec, maze: @maze)
    solver.save!
    return solver
  end

  test("#index") do
    solver_200_0 = create_solver(:solver_200_0, 200)
    solver_100_0 = create_solver(:solver_100_0, 100)
    solver_300_0 = create_solver(:solver_300_0, 300)
    create_solver(:solver_200_1, 300, email: solver_200_0.email) # same email
    create_solver(:solver_000_0, -1) # incorrect answer
    solver_200_2 = create_solver(:solver_200_2, 200, # same elapsed time
                                 nbytes_offset: -10)
    solver_200_3 = create_solver(:solver_200_3, 200, # same elapsed time and nbytes
                                 # less than solver_200_0
                                 created_at: solver_200_0.created_at - 1.hours)
    expected_solvers = [
      solver_100_0,
      solver_200_2, solver_200_3, solver_200_0,
      solver_300_0,
    ]

    get(solvers_url)

    assert_response(:success)
    assert_equal(expected_solvers.map(&:username),
                 assigns(:solvers).map(&:username))
  end

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
