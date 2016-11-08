FactoryGirl.define do
  factory(:solver) do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.org" }

    before(:create) do |solver, evaluator|
      solver.run_and_set_result
    end
  end

  factory(:valid_solver, parent: :solver) do
    content (Rails.root / "test/bin/valid_solver.rb").read
  end

  factory(:invalid_solver, parent: :solver) do
    content (Rails.root / "test/bin/invalid_solver.rb").read
  end
end
