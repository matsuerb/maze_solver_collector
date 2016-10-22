class CreateSolvers < ActiveRecord::Migration[5.0]
  def change
    create_table :solvers do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.text :content, null: false
      t.integer :elapsed_usec, null: false
      t.integer :nbytes, null: false

      t.timestamps
    end
    add_index :solvers, :email
  end
end
