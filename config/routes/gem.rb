# frozen_string_literal: true

resources :classes, only: [:index, :show] do
  draw :methods
end

resources :modules, only: [:index, :show] do
  draw :methods
end

draw :methods

resources :guides, only: [:index, :show]
resources :search, only: [:index]
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
