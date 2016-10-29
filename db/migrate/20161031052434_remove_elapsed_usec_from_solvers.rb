class RemoveElapsedUsecFromSolvers < ActiveRecord::Migration[5.0]
  def change
    remove_column :solvers, :elapsed_usec, :integer
  end
end
