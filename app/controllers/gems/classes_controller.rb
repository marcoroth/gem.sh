# frozen_string_literal: true

class Gems::ClassesController < Gems::BaseController
  include GemClassScoped

  def index
  end

  def show
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @class.qualified_name }
    @namespace = @gem.find_namespace(@class.qualified_namespace)
  end
end
