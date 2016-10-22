class CreateSolvers < ActiveRecord::Migration[5.0]
  def change
    create_table :solvers do |t|
      t.string :username
      t.string :email
      t.text :content
      t.integer :elapsed_usec
      t.integer :nbytes

      t.timestamps
    end
    add_index :solvers, :email
  end
end
