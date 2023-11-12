# frozen_string_literal: true

Rails.application.routes.draw do
  root "homes#index"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  post "/login", to: "sessions#create"
  post "lock_off", to: "sessions#lock_off"

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
    resources :incentives
    resources :learns
  end
end
