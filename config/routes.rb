Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "dashboard", to: "pages#dashboard"
  get "uikit", to: "pages#uikit"
  patch "bookings/:id/cancel", to: "bookings#cancel", as: "cancel_booking"

  resources :rides, except: [:destroy] do
    resources :bookings, only: %i[index create] do
      resources :messages, only: %i[index]
    end
    resources :reviews, only: %i[create]
  end

  resources :chatrooms, only: %i[index]
end
