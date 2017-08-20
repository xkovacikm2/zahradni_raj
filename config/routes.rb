Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  root 'dashboard#home'

  resources :users
end
