Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "dashboard", to: "pages#dashboard"
  resources :rides, except: [:destroy] do
    resources :bookings, only: %i[index create update] do
      resources :messages, only: %i[index]
    end
    resources :reviews, only: %i[create]
  end
end
