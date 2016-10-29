class Maze < ApplicationRecord
  validates :correct_answer, uniqueness: true
end
