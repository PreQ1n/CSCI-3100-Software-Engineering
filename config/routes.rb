Rails.application.routes.draw do
  root "pages#hello"
  resources :venues
  resources :cuhk_equipments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/venues", to: "venues#index"
  get "/cuhk_equipments", to: "cuhk_equipments#index"
  # get "/eqyipment"
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

  post 'confirm', to: 'confirmation#confirm'
end
