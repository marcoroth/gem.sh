# frozen_string_literal: true

class Gems::ClassMethodsController < ApplicationController
  include GemScoped
  include GemTargetScoped

  def show
    @method = @target.class_methods.find { |class_method| class_method.name == params[:id] }

    raise(GemConstantNotFoundError, "Class method '#{params[:id]}' not found on '#{@target.try(:qualified_name)}'") if @method.nil?

    render "gems/methods/show"
  end
end
