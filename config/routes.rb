# frozen_string_literal: true

Rails.application.routes.draw do
  root "homes#index"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  post "/login", to: "sessions#create"
  post "lock_off", to: "sessions#lock_off"

  resources :events, only: %i(index show)
  resources :reservations, only: %i(index create update destroy) do
    collection do
      get "reservation_status"
      get "reserved_list"
    end
    member do
      get "reserve_confirm"
      post "reserved_confirmation"
    end
  end
  resources :tmp_member_infos, only: %i(new create) do
    collection do
      post "confirm"
      get "get_confirm"
      get "complete"
    end
  end

  get "/admin", to: "admin#index"
  namespace :admin do
    resources :seminars
    resources :posts
    resources :incentives, only: %i(index edit update)
    resources :learns
    resources :learn_categories
  end
end
