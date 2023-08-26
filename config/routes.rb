# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tmp_member_infos, only: %i(new create) do
    collection do
      post "confirm"
      get "get_confirm"
      get "complete"
    end
  end
end
