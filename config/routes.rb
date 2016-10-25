Rails.application.routes.draw do
  root "solvers#index"

  resources :solvers, only: [:index, :show, :new, :create]
end
