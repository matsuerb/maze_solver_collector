class SolversController < ApplicationController
  before_action :set_solver, only: [:show]

  # GET /solvers
  def index
    @solvers = Solver.all
  end

  # GET /solvers/1
  def show
  end

  # GET /solvers/new
  def new
    @solver = Solver.new
  end

  # POST /solvers
  def create
    @solver = Solver.new(solver_params)
    @solver.run_and_set_result

    respond_to do |format|
      if @solver.save
        format.html { render :complete }
      else
        format.html { render :new }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_solver
    @solver = Solver.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def solver_params
    params.require(:solver).permit(:username, :email, :content)
  end
end
