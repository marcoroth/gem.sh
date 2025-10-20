class Gems::BaseController < ApplicationController
  before_action :set_gem

  rescue_from GemNotFoundError, Gems::NotFound do |exception|
    redirect_to gems_path, notice: exception.message
  end

  rescue_from GemConstantNotFoundError do |exception|
    redirect_to gem_version_gem_path(@gem.name, @gem.version), notice: exception.message
  end

  private

  def set_gem
    if gem = params[:gem]
      version = perams[:version] || GemSpec.latest_version_for(gem)
      @gem = GemSpec.find(gem, version) or raise GemNotFoundError.new(gem, version)
    end
  end
end
