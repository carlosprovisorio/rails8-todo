Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  # Root
  root "home#index"

  # Registration
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  # Sessions
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :password_resets, only: [ :new, :create, :edit, :update ]
end
