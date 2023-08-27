# frozen_string_literal: true

module GemScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_gem

    rescue_from "GemNotFoundError", "Gems::NotFound" do |exception|
      redirect_to gems_path, notice: exception.message
    end

    rescue_from "GemConstantNotFoundError" do |exception|
      redirect_to gem_version_path(@gem.name, @gem.version), notice: exception.message
    end
  end

  private

  def set_gem
    @gem = GemSpec.find(params[:gem], params[:version]) || raise(GemNotFoundError.new(params[:gem], params[:version]))
  end
end
