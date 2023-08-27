# frozen_string_literal: true

module GemModuleScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_module, except: :index
  end

  private

  def set_module
    @module = @gem.find_module!(params[:id])
  end
end
