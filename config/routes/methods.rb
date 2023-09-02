# frozen_string_literal: true

resources :instance_methods, only: :show
resources :class_methods, only: :show

# TODO: remove redirects
get "/instance_method/:id", to: redirect { |_params, request|
  request.url.gsub("/instance_method/", "/instance_methods/")
}

get "/class_method/:id", to: redirect { |_params, request|
  request.url.gsub("/class_method/", "/class_methods/")
}
