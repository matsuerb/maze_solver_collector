class SolversController < ApplicationController
  before_action :set_solver, only: [:show]

  # GET /solvers
  def index
    @solvers = Solver.eager_load(:results).find_each.lazy.select { |solver|
      solver.done? && solver.success?
    }.sort_by { |solver|
      [solver.elapsed_usec, solver.nbytes, solver.created_at]
    }.uniq(&:email)
  end

  # GET /solvers/:id
  def show
    respond_to do |format|
      format.html {}
      format.json do
        @results = @solver.mazes.collect { |m|
          @solver.results.where(maze_id: m.id).first || Result.new(maze: m, solver: @solver)
        }
        # TODO: 個別に表示するようになったら削除する。
        correct_answers = @solver.results.correct_answers
        @correct_ansewer_cnt = correct_answers.count
        @total_time = correct_answers.sum(:elapsed_usec)
      end
    end
  end

  # GET /solvers/new
  def new
    @solver = Solver.new
  end

  # POST /solvers
  def create
    @solver = Solver.new(solver_params)

    respond_to do |format|
      if @solver.save
        format.html { redirect_to @solver, notice: 'Solver was successfully created.' }
        @solver.delay.run_and_save_result
      else
        data = {
          username: @solver.username,
          email: @solver.email,
          error: @solver.errors.full_messages,
        }
        format.html {
          redirect_to({action: :new, anchor: :form}, {flash: data})
        }
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
