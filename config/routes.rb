Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  root 'dashboard#home'

  resources :users
  resources :customers
  resources :offers, only: [:new, :create, :destroy]
end
