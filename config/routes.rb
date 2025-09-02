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
  resource :password_reset, only: [ :new, :create, :edit, :update ]

  get "up" => "rails/health#show", as: :rails_health_check

  resources :lists do
    patch :reorder, on: :collection
    resources :tasks do
      patch :reorder, on: :collection
      member { patch :toggle_status }
      resources :task_items, only: [ :create, :update, :destroy ]
      delete "attachments/:attachment_id", to: "attachments#destroy", as: :attachment
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
