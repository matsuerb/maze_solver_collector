class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :maze, foreign_key: true, index: false, null: false
      t.references :solver, foreign_key: true, index: false, null: false
      t.integer :elapsed_usec, null: false

      t.timestamps
      t.index [:solver_id, :maze_id], unique: true
    end
  end
end
