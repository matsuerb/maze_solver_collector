class Maze < ApplicationRecord
  validates :correct_answer, uniqueness: true

  def question
    return correct_answer.gsub(":", " ")
  end
end
