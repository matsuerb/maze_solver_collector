json.solver do |json|
  json.id @solver.id
  json.results @results.map {|r| {maze_id: r.maze_id, time: r.elapsed_usec}}
  # TODO: 個別に表示するようになったらtotal_timeまで削除する。
  json.correct_answer_cnt @correct_ansewer_cnt
  json.total_time @total_time
  json.nbytes @solver.nbytes
  json.ended @solver.done?
end