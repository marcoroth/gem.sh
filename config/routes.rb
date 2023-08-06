# frozen_string_literal: true

Rails.application.routes.draw do
  root "page#home"

  get "/home" => "page#home", as: :home
  get "/docs" => "page#docs", as: :docs
  get "/community" => "page#community", as: :community

  get "/search" => "gems#search", as: :gems_search

  scope "/gems/:gem" do
    scope "/v:version", version: /.*/ do
      scope "/class/:class" do
        get "/instance_method/:name" => "gems#instance_method", as: :gem_class_instance_method
        get "/class_method/:name" => "gems#class_method", as: :gem_class_class_method
        get "/" => "gems#klass", as: :gem_class
      end

      scope "/module/:module" do
        get "/instance_method/:name" => "gems#instance_method", as: :gem_module_instance_method
        get "/class_method/:name" => "gems#class_method", as: :gem_module_class_method
        get "/" => "gems#nodule", as: :gem_module
      end

      get "/instance_method/:name" => "gems#instance_method", as: :gem_instance_method
      get "/class_method/:name" => "gems#class_method", as: :gem_class_method

      get "/files" => "gems#source", as: :gem_source
      get "/files/:file" => "gems#source", file: /.*/, as: :gem_file

      get "/announcements" => "gems#announcements", as: :gem_announcements
      get "/articles" => "gems#articles", as: :gem_articles
      get "/changelogs" => "gems#changelogs", as: :gem_changelogs
      get "/community" => "gems#community", as: :gem_community
      get "/guides" => "gems#guides", as: :gem_guides
      get "/metadata" => "gems#metadata", as: :gem_metadata
      get "/playground" => "gems#playground", as: :gem_playground
      get "/reference" => "gems#reference", as: :gem_reference
      get "/stats" => "gems#stats", as: :gem_stats
      get "/tutorials" => "gems#tutorials", as: :gem_tutorials
      get "/types" => "gems#types", as: :gem_types
      get "/versions" => "gems#versions", as: :gem_versions
      get "/videos" => "gems#videos", as: :gem_videos
      get "/wiki" => "gems#wiki", as: :gem_wiki

      get "/" => "gems#show", as: :gem_version
    end

    get "/" => "gems#show", as: :gem
  end

  resources :gems, only: [:index]
end
