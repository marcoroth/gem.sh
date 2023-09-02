# frozen_string_literal: true

scope "/", as: :gem do
  resources :gems, only: [], param: :gem, as: :gem, module: :gems do
    member do
      scope "/v:version", as: :version, version: /.*/ do
        draw :gem
        get "/" => "/gems#show"
      end

      draw :gem
    end
  end
end

get "/gems" => "gems#index", as: :gems
get "/gems/:gem" => "gems#show", as: :gem
