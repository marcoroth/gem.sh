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
      "https://github.com/socketry/async/raw/main/logo.svg",
      "https://camo.githubusercontent.com/8ee47f768c8b892d3641aaabc335a69601c2817cab686f5a00e90ef4f81e3521/68747470733a2f2f726f64612e6a6572656d796576616e732e6e65742f696d616765732f726f64612d6c6f676f2e737667",
    ]
  end

  def types
    @sample_count = ::Types::Sample.count
    @samples = ::Types::Sample.group(
      :gem_name,
      :gem_version
    )
      .order(count: :desc)
      .count
  rescue StandardError
    @sample_count = 0
    @samples = []
  end

  def docs
  end

  def community
  end
end
