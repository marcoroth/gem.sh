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
      get "/" => "gems#show", as: :gem_version
    end

    get "/" => "gems#show", as: :gem
  end

  resources :gems, only: [:index]
end
