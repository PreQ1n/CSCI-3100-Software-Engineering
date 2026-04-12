Rails.application.routes.draw do
  resources :equipment
  resources :equipment_records
<<<<<<< HEAD
  resources :venue_records do
    collection do
      # GET /venue_records/booked_slots?venue_id=1&date=2026-04-11
      get :booked_slots
    end
  end
  root "pages#hello"
  resources :venues
  # resources :cuhk_equipments
=======
  resources :venue_records
  root "pages#hello"
  resources :venues
  #resources :cuhk_equipments
>>>>>>> map-api
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/venues", to: "venues#index"
<<<<<<< HEAD
  # get "/cuhk_equipments", to: "cuhk_equipments#index"

=======
  #get "/cuhk_equipments", to: "cuhk_equipments#index"
  
>>>>>>> map-api
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "confirmation", to: "pages#confirmation"
  get "calendar", to: "pages#calendar"
  get "history", to: "pages#history"
<<<<<<< HEAD
  get "analytics_dashboard", to: "pages#analytics_dashboard"

  post "confirm", to: "confirmation#confirm"
=======

  post 'confirm', to: 'confirmation#confirm'
>>>>>>> map-api
end
