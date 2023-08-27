# frozen_string_literal: true

class Gems::PagesController < ApplicationController
  include GemScoped

  def show
    render params[:id].to_sym
  end
end
