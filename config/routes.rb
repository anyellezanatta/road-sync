Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "dashboard", to: "pages#dashboard"
  get "uikit", to: "pages#uikit"

  patch "bookings/:id/cancel", to: "bookings#cancel", as: "cancel_booking"

  resources :rides, except: [:destroy] do
    resources :bookings, only: %i[create]
    resources :chatrooms, only: %i[show create] do
      resources :messages, only: %i[create]
    end
    resources :reviews, only: %i[create]
  end

  resources :drivers, only: [:show]
  resources :bookings, only: %i[show] do
    resources :reviews, only: [:new, :create]
  end
end
