Rails.application.routes.draw do
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

  resource :password_reset, only: [ :new, :create, :edit, :update ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
