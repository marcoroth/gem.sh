# frozen_string_literal: true

class Gems::InstanceMethodsController < Gems::BaseController
  include GemTargetScoped

  def show
    @method = @target.instance_methods.find { |instance_method| instance_method.name == params[:id] }

    raise(GemConstantNotFoundError, "Instance method '#{params[:id]}' not found on '#{@target.try(:qualified_name)}'") if @method.nil?

    render "gems/methods/show"
  end
end
