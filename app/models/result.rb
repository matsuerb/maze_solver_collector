class Result < ApplicationRecord
  belongs_to :maze
  belongs_to :solver

  def success?
    return elapsed_usec >= 0
  end

  def elapsed_sec
    return elapsed_usec / 1_000_000.0
  end
end
