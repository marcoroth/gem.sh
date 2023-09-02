# frozen_string_literal: true

Rails.application.routes.draw do
  root "page#home"

  get "/home" => "page#home", as: :home
  get "/docs" => "page#docs", as: :docs
  get "/community" => "page#community", as: :community
  get "/types" => "page#types", as: :types

  resources :search, only: :index

  draw :gems
  draw :api
end
