# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    namespace :types do
      resources :samples, only: :create
    end
  end
end
