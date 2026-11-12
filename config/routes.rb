Rails.application.routes.draw do
  root "dashboard#show"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  resource :dashboard, only: :show
  resources :customers
  resources :plans
  resources :subscriptions, only: %i[index show new create] do
    member { patch :activate; patch :cancel }
  end
  resources :invoices, only: %i[index show] do
    member { post :simulate_payment }
  end
  resources :audit_events, only: :index
  resource :settings, only: %i[show update]

  namespace :api do
    namespace :v1 do
      resources :customers, only: %i[index show create]
      resources :plans, only: %i[index show]
      resources :subscriptions, only: %i[index show create] do
        member { patch :cancel }
      end
      resources :invoices, only: %i[index show]
      post "webhooks/payments", to: "webhooks#payments"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
