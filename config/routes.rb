Rails.application.routes.draw do
  resources :solvers, only: [:index, :show, :new, :create]
end
