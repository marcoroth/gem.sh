# frozen_string_literal: true

Rails.application.routes.draw do
  root "page#home"

  get "/home" => "page#home", as: :home
  get "/docs" => "page#docs", as: :docs
  get "/community" => "page#community", as: :community
  get "/types" => "page#types", as: :types

  scope "/gems/:gem" do
    scope "/v:version", version: /.*/ do
      namespace :gems, as: :gem, path: "/" do
        resources :classes, only: [:index, :show] do
          resources :instance_methods, only: :show
          resources :class_methods, only: :show
        end

        resources :modules, only: [:index, :show] do
          resources :instance_methods, only: :show
          resources :class_methods, only: :show
        end

        resources :instance_methods, only: :show
        resources :class_methods, only: :show

        resources :guides, only: [:index, :show]
        resources :docs, only: [:index, :show]
        resources :files, only: [:index, :show], constraints: { id: /.*/ }
        resources :types, only: :index
        resources :versions, only: :index
        resources :rbs, only: :index

        pages = [
          "announcements",
          "articles",
          "changelogs",
          "community",
          "metadata",
          "playground",
          "readme",
          "reference",
          "stats",
          "tutorials",
          "videos",
          "wiki",
        ]

        pages.each do |page|
          get page => "pages#show", id: page, as: page
        end
      end

      get "/" => "gems#show", as: :gem_version
    end

    get "/" => "gems#show", as: :gem
  end

  resources :search, only: :index
  resources :gems, only: :index

  namespace :api do
    namespace :v1 do
      namespace :types do
        resources :samples, only: :create
      end
    end
  end
end
