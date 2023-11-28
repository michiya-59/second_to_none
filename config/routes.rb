# frozen_string_literal: true

Rails.application.routes.draw do
  get "learns/index"
  get "connect_services/index"
  root "homes#index"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  post "/login", to: "sessions#create"
  post "lock_off", to: "sessions#lock_off"

  resources :introducers, only: %i(index) do
    collection do
      get "search"
    end
  end
  resources :users, only: %i(show edit update)
  resources :approvals, only: %i(index edit update)
  resources :learns, only: %i(index) do
    collection do
      get "learn_list"
    end
  end
  resources :connect_services, only: %i(index) do
    collection do
      get "whitening"
      get "photography"
      get "movie_edit"
      get "web_site_creation"
      get "rent"
      get "moving"
      get "beauty_clinic"
      get "hair_removal_medical"
      get "hair_removal_beauty"
      get "personal_color"
      get "job_change_agent"
      get "mobile_communicating_charge_rethink"
    end
  end
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
