class SolversController < ApplicationController
  before_action :set_solver, only: [:show, :edit, :update, :destroy]

  # GET /solvers
  # GET /solvers.json
  def index
    @solvers = Solver.all
  end

  # GET /solvers/1
  # GET /solvers/1.json
  def show
  end

  # GET /solvers/new
  def new
    @solver = Solver.new
  end

  # GET /solvers/1/edit
  def edit
  end

  # POST /solvers
  # POST /solvers.json
  def create
    @solver = Solver.new(solver_params)

    respond_to do |format|
      if @solver.save
        format.html { redirect_to @solver, notice: 'Solver was successfully created.' }
        format.json { render :show, status: :created, location: @solver }
      else
        format.html { render :new }
        format.json { render json: @solver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solvers/1
  # PATCH/PUT /solvers/1.json
  def update
    respond_to do |format|
      if @solver.update(solver_params)
        format.html { redirect_to @solver, notice: 'Solver was successfully updated.' }
        format.json { render :show, status: :ok, location: @solver }
      else
        format.html { render :edit }
        format.json { render json: @solver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solvers/1
  # DELETE /solvers/1.json
  def destroy
    @solver.destroy
    respond_to do |format|
      format.html { redirect_to solvers_url, notice: 'Solver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_solver
    @solver = Solver.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def solver_params
    params.require(:solver).permit(:username, :email, :content, :elapsed_usec, :nbytes)
  end
end
