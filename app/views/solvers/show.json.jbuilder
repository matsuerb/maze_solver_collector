json.solver do |json|
  json.id @solver.id
  json.correct_answer_cnt @correct_ansewer_cnt
  json.total_time @total_time
  json.nbytes @solver.nbytes
  json.ended @solver.done?
end