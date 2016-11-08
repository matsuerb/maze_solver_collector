require 'test_helper'

class MazeTest < ActiveSupport::TestCase
  sub_test_case("#question") do
    test("問題文を返す") do
      maze = build(:maze)
      assert_equal(<<EOS, maze.question)
###########
S #     # #
# # ### # #
#   #   # #
##### ### #
#     #   #
# ### # ###
#   # # # #
### ### # #
#         G
###########
EOS
    end
  end
end
