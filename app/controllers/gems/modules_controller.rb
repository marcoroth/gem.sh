# frozen_string_literal: true

class Gems::ModulesController < ApplicationController
  include GemScoped
  include GemModuleScoped

  def index
  end

  def show
    @modules = @gem.modules.select { |mod| mod.qualified_namespace == @module.qualified_name }
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @module.qualified_name }
  end
end
