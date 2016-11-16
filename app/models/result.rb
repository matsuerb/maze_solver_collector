class Result < ApplicationRecord
  belongs_to :maze
  belongs_to :solver

  def success?
    return elapsed_usec >= 0
  end
end
