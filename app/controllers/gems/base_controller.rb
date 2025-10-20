class Gems::BaseController < ApplicationController
  before_action :set_gem
  def self.set_target(...) = before_action(:set_target, ...)

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

  def set_target
    @target =
      case
      when params[:class_id]  then @gem.find_class!(params[:class_id])
      when params[:module_id] then @gem.find_module!(params[:module_id])
      else
        @gem.info.analyzer
      end

    @namespace = @gem.find_namespace(@target.qualified_namespace) if params[:class_id]
  end
end
