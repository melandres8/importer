# frozen_string_literal: true

Rails.application.routes.draw do
  root 'imported_files#new'
  devise_for :users
  resources :contacts
  resources :invalid_contacts, only: [:index]
  resources :imported_files do
    collection { post :import }
  end
end
