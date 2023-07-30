class GemsController < ApplicationController
  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @gem = Gemspec.find(params[:id])
    @namespaces = @gem.modules
    @classes = @gem.classes
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def namespace
    @gem = Gemspec.find(params[:id])
    @namespace = params[:namespace]
    @namespaces = @gem.modules.filter { |namespace| namespace.qualified_name.start_with?(@namespace) }
    @classes = @gem.classes.filter { |namespace| namespace.qualified_name.start_with?("#{@namespace}::") }

    render :show
  end
end
