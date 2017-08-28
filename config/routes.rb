Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  root 'dashboard#home'

  resources :users
  resources :customers
  resources :offers, except: [:index, :show]
  resources :offer_files, only: :destroy
  resources :recruitment_centers, except: :show
  resources :countries, except: :show
  resources :regions, except: :show
  resources :request_categories, except: :show
  resources :requests, except: [:show, :index]
  resources :customer_statuses, except: :show
end
