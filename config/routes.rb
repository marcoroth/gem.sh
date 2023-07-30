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
        get "/" => "gems#namespace", as: :gem_module
      end

      get "/instance_method/:name" => "gems#instance_method", as: :gem_instance_method
      get "/class_method/:name" => "gems#class_method", as: :gem_class_method

      get "/metadata" => "gems#metadata", as: :gem_metadata
      get "/source" => "gems#source", as: :gem_source
      get "/guides" => "gems#guides", as: :gem_guides
      get "/versions" => "gems#versions", as: :gem_versions
      get "/tutorials" => "gems#tutorials", as: :gem_tutorials
      get "/wiki" => "gems#wiki", as: :gem_wiki
      get "/reference" => "gems#reference", as: :gem_reference
      get "/videos" => "gems#videos", as: :gem_videos
      get "/articles" => "gems#articles", as: :gem_articles
      get "/types" => "gems#types", as: :gem_types
      get "/community" => "gems#community", as: :gem_community
      get "/stats" => "gems#stats", as: :gem_stats
      get "/announcements" => "gems#announcements", as: :gem_announcements
      get "/" => "gems#show", as: :gem_version
    end

    get "/" => "gems#show", as: :gem
  end

  resources :gems, only: [:index]
end
