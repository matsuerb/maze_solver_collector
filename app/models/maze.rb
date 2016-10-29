class Maze < ApplicationRecord
  has_many :results
  has_many :solvers, through: :results

  validates :correct_answer, uniqueness: true

  def question
    return correct_answer.gsub(":", " ")
  end
end
