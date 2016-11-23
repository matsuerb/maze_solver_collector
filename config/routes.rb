Rails.application.routes.draw do
  root "solvers#new"

  resources :solvers, only: [:index, :new, :create, :show]
end
