class CreateMazes < ActiveRecord::Migration[5.0]
  def change
    create_table :mazes do |t|
      t.text :correct_answer

      t.timestamps
    end
  end
end
