# frozen_string_literal: true

class Gems::SearchController < ApplicationController
  include GemScoped

  def index
    query = params[:q].downcase

    @modules = @gem.modules.select { |mod| mod.qualified_name.downcase.include?(query) }
    @classes = @gem.classes.select { |klass| klass.qualified_name.downcase.include?(query) }
    @methods = @gem.all_methods.select { |method| method.name.downcase.include?(query) }
  end
end
