# frozen_string_literal: true

module GemTargetScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_target
  end

  private

  def set_target
    if params[:class_id]
      @target = @gem.find_class!(params[:class_id])
      @namespace = @gem.find_namespace(@target.qualified_namespace)
    elsif params[:module_id]
      @target = @gem.find_module!(params[:module_id])
    else
      @target = @gem.info.analyzer
    end
  end
end
