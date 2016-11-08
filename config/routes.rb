Rails.application.routes.draw do
  root "solvers#index"

  resources :solvers, only: [:new, :create, :show]
end
