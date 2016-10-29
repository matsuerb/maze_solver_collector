FactoryGirl.define do
  factory(:maze) do
    correct_answer(<<EOS)
###########
S:#:::::# #
#:#:###:# #
#:::#:::# #
#####:### #
#:::::#   #
#:### # ###
#:::# # # #
###:### # #
#  :::::::G
###########
EOS
  end
end
