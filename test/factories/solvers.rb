FactoryGirl.define do
  factory(:solver) do
    username { |n| "user#{n}" }
    email { |n| "user#{n}@example.org" }
  end

  factory(:valid_solver, parent: :solver) do
    content (Rails.root / "test/bin/valid_solver.rb").read
  end

  factory(:invalid_solver, parent: :solver) do
    content (Rails.root / "test/bin/invalid_solver.rb").read
  end
end