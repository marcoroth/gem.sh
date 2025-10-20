# frozen_string_literal: true

class Gems::ModulesController < Gems::BaseController
  def index
  end

  def show
    @module = @gem.find_module!(params[:id])

    @modules = @gem.modules.select { |mod| mod.qualified_namespace == @module.qualified_name }
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @module.qualified_name }
  end
end
