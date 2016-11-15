class Result < ApplicationRecord
  belongs_to :maze
  belongs_to :solver

  scope :collect_answers, -> { where('elapsed_usec > -1') }
end
