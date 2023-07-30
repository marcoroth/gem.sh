Rails.application.routes.draw do
  root "page#home"

  get "/home" => "page#home", as: :home
  get "/docs" => "page#docs", as: :docs
  get "/community" => "page#community", as: :community

  get "/search" => "gems#search", as: :gems_search

  get "/gems/:gem" => "gems#show", as: :gem
  get "/gems/:gem/class/:name" => "gems#klass", as: :gem_class
  get "/gems/:gem/module/:name" => "gems#namespace", as: :gem_namespace

  get "/gems/:gem/class/:class/instance_method/:name" => "gems#instance_method", as: :gem_class_instance_method
  get "/gems/:gem/module/:module/instance_method/:name" => "gems#instance_method", as: :gem_module_instance_method

  resources :gems, only: [:index]
end
