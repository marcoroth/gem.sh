# frozen_string_literal: true

class PageController < ApplicationController
  def home
    @featured_gems = [
      GemSpec.find("nokogiri"),
      GemSpec.find("async"),
      GemSpec.find("roda"),
    ]

    @images = [
      "https://nokogiri.org/images/nokogiri-serif-black.png",
      "https://github.com/socketry/async/raw/main/assets/logo-v1.svg",
      "https://github.com/jeremyevans/roda/raw/master/www/public/images/roda-logo.svg",
    ]
  end

  def types
    @sample_count = ::Types::Sample.count
    @samples = ::Types::Sample.group(:gem_name, :gem_version).order(count: :desc).count
  rescue StandardError
    @sample_count = 0
    @samples = []
  end

  def docs
  end

  def community
  end
end
