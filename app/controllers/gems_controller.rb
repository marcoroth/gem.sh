class GemsController < ApplicationController
  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @gem = Gemspec.find(params[:gem])
    @namespaces = @gem.modules.select { |namespace| namespace.namespace.split("::").count <= 1 }
    @classes = @gem.classes
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def namespace
    @gem = Gemspec.find(params[:gem])
    @namespace = params[:name]
    @namespaces = @gem.modules.select { |namespace| namespace.namespace == @namespace }
    @classes = @gem.classes.select { |namespace| namespace.namespace == @namespace }

    render :show
  end

  def klass
    @gem = Gemspec.find(params[:gem])
    @klass = @gem.classes.find { |klass| klass.qualified_name == params[:name] }
  end

  def instance_method
    @gem = Gemspec.find(params[:gem])
    @klass = @gem.classes.find { |klass| klass.qualified_name == params[:class] }
    @instance_method = params[:name]
  end
end
