Rails.application.routes.draw do
  root "solvers#new"

  resources :solvers, only: [:new, :create, :show]
end
