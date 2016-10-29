class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :maze, foreign_key: true
      t.references :solver, foreign_key: true
      t.integer :elapsed_usec

      t.timestamps
    end
  end
end
