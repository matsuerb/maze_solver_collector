class CreateMazes < ActiveRecord::Migration[5.0]
  def change
    create_table :mazes do |t|
      t.text :correct_answer, null: false

      t.timestamps
    end
    add_index :mazes, :correct_answer, unique: true
  end
end
