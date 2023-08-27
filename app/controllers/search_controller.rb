# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @result = GemSearch.search(params[:name])
  end
end
