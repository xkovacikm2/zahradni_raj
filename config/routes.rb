Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'sessions'}

  root 'dashboard#home'

  resources :customers do
    collection do
      get 'write_emails', to: 'customers#write_emails'
      post 'send_emails', to: 'customers#send_emails'
    end
  end

  resources :users
  resources :offers, except: [:index, :show]
  resources :offer_files, only: :destroy
  resources :recruitment_centers, except: :show
  resources :countries, except: :show
  resources :regions, except: :show
  resources :request_categories, except: :show
  resources :requests, except: [:show, :index]
  resources :customer_statuses, except: :show
end
