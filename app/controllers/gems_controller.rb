class GemsController < ApplicationController
  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @gem = Gemspec.find(params[:id])
    @namespaces = @gem.info.analyzer.modules.sort_by(&:qualified_name)
    @classes = @gem.info.analyzer.classes.sort_by(&:qualified_name)
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def namespace
    @gem = Gemspec.find(params[:id])
    @namespace = params[:namespace]
    @namespaces = @gem.info.analyzer.modules.sort_by(&:qualified_name).filter { |namespace| namespace.qualified_name.start_with?(@namespace) }
    @classes = @gem.info.analyzer.classes.sort_by(&:qualified_name).filter { |namespace| namespace.qualified_name.start_with?("#{@namespace}::") }

    render view: :show
  end
end
