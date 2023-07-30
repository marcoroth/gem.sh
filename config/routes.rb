Rails.application.routes.draw do
  root "page#home"

  get "/home" => "page#home", as: :home
  get "/docs" => "page#docs", as: :docs
  get "/community" => "page#community", as: :community

  get "/search" => "gems#search", as: :gems_search

  get "/gems/:id/module/:namespace" => "gems#namespace", as: :gem_namespace

  resources :gems, only: [:index, :show]
end
