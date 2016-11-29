class AddDivisionToSolvers < ActiveRecord::Migration[5.0]
  # 将来Solverモデルが消えてる時にこのmigrationを通ってもSolverモデルがなくて例外にならなくするために定義。
  class Solver < ApplicationRecord
    DivisionVal={
        general: 0, # 一般
        student: 1, # 学生
    }
  end

  def up
    add_column :solvers, :division, :integer, default: 0, null: false
    begin
      transaction do
        execute("UPDATE solvers SET division = #{Solver::DivisionVal[:general]}")
      end
    rescue
      down
      raise
    end
  end

  def down
    remove_column :solvers, :division, :integer
  end

end
