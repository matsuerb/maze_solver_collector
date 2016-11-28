class AddDivisionToSolvers < ActiveRecord::Migration[5.0]
  def change
    add_column :solvers, :division, :integer
  end
end
