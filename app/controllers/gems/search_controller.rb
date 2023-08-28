# frozen_string_literal: true

class Gems::SearchController < ApplicationController
  include GemScoped

  def index
    query = params[:q].to_s.downcase

    @modules = @gem.modules.select { |mod| mod.qualified_name.downcase.include?(query) }
    @classes = @gem.classes.select { |klass| klass.qualified_name.downcase.include?(query) }
    @methods = @gem.all_methods.select { |method| method.name.downcase.include?(query) }

    respond_to do |format|
      format.html { redirect_to gem_version_path(@gem.name, @gem.version) }
      format.turbo_stream
    end
  end
end
