# frozen_string_literal: true

module GemClassScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_class, except: :index
  end

  private

  def set_class
    @class = @gem.find_class!(params[:id])
  end
end
