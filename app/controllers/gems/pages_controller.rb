# frozen_string_literal: true

class Gems::PagesController < Gems::BaseController
  def show
    render params[:id].to_sym
  end
end
