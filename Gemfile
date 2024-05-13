# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.2"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mswin, :mswin64, :mingw, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Makes http fun again! Ain't no party like a httparty, because a httparty don't stop.
gem "httparty", "~> 0.22.0"

# A framework for creating reusable, testable & encapsulated view components
gem "view_component", "~> 3.12"

# Interact with the Ruby syntax tree
gem "prism", "~> 0.29"

# A pure Ruby code highlighter that is compatible with Pygments
gem "rouge", "~> 4.2"

# Embed SVG documents in your Rails views and style them with CSS
gem "inline_svg", "~> 1.9"

# A documentation generation tool for the Ruby programming language
gem "yard", "~> 0.9.36"

# Embedded documentation generator for the Ruby
gem "rdoc"

# Rails view helper to manage "active" state of a link
gem "active_link_to", "~> 1.0"

# The safe Markdown parser, reloaded.
gem "redcarpet", "~> 3.6"

# Sanitizing HTML fragments in Rails applications
gem "rails-html-sanitizer", "~> 1.6"

# Easily configure styles and apply them as classes.
gem "class_variants", "~> 0.0.7"

# Framework-agnostic XML Sitemap generator
gem "sitemap_generator", "~> 6.3"

# Search Engine Optimization (SEO) for Ruby on Rails applications.
gem "meta-tags"

# Ruby wrapper for the RubyGems.org API
gem "gems", github: "marcoroth/gems", branch: "v2-api"

# Performances & exceptions monitoring for Ruby on Rails applications
gem "rorvswild", "~> 1.7"

# A Ruby static code analyzer and formatter, based on the community Ruby style guide.
gem "rubocop", "~> 1.63"

# A RuboCop extension focused on enforcing Rails best practices and coding conventions.
gem "rubocop-rails", "~> 2.24"

# gem "type_fusion", path: "../type_fusion"

# Collaborative Ruby type sampling
gem "type_fusion", "0.0.6"

# View helpers for the beautiful hand-crafted SVG icons, Heroicons.
gem "heroicon", "~> 1.0"

# Tool to interactively execute Ruby expressions read from the standard input.
gem "irb", "~> 1.13"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: [:mri, :mswin, :mswin64, :mingw, :x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  # gem "capybara"
  # gem "selenium-webdriver"
  # gem "webdrivers"

  # A library for setting up Ruby objects as test data.
  gem "factory_bot", "~> 6.4"
end
