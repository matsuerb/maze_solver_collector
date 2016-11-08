class Result < ApplicationRecord
  belongs_to :maze
  belongs_to :solver
end
