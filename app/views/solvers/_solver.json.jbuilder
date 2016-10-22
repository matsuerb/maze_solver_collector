json.extract! solver, :id, :username, :email, :content, :elapsed_usec, :nbytes, :created_at, :updated_at
json.url solver_url(solver, format: :json)