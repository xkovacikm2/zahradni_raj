Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  root 'dashboard#home'

  resources :users
  resources :customers
  resources :offers, only: [:new, :create, :destroy]
  resources :recruitment_centers, except: :show
  resources :countries, except: :show
  resources :regions, except: :show
end
