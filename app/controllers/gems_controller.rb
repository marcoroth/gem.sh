class GemsController < ApplicationController
  before_action except: :index do
    @gem = Gemspec.find(params[:gem], params[:version])
    @version = @gem.version
  end

  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @namespaces = @gem.modules.select { |namespace| namespace.namespace.split("::").count <= 1 }
    @classes = @gem.classes
    @instance_methods = @gem.instance_methods
    @class_methods = @gem.class_methods
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def namespace
    @namespace = @gem.modules.find { |namespace| namespace.qualified_name == params[:module] }
    @namespaces = @gem.modules.select { |namespace| namespace.namespace == params[:module] }
    @classes = @gem.classes.select { |namespace| namespace.namespace == params[:module] }

    @instance_methods = Array.wrap(@namespace && @namespace.instance_methods)
    @class_methods = Array.wrap(@namespace && @namespace.class_methods)

    render :show
  end

  def klass
    @klass = @gem.classes.find { |klass| klass.qualified_name == params[:class] }
    @namespace = @gem.modules.find { |namespace| namespace.qualified_name == @klass.namespace }
    @instance_methods = @klass.instance_methods
    @class_methods = @klass.class_methods
  end

  def instance_method
    if params[:class]
      @klass = @gem.classes.find { |klass| klass.qualified_name == params[:class] }
      @namespace = @gem.modules.find { |namespace| namespace.qualified_name == @klass.namespace }
      @method = @klass.instance_methods.find { |instance_method| instance_method.name == params[:name] }
    elsif params[:module]
      @namespace = @gem.modules.find { |namespace| namespace.qualified_name == params[:module] }
      @method = @namespace.instance_methods.find { |instance_method| instance_method.name == params[:name] }
    end

    render :method
  end

  def class_method
    if params[:class]
      @klass = @gem.classes.find { |klass| klass.qualified_name == params[:class] }
      @namespace = @gem.modules.find { |namespace| namespace.qualified_name == @klass.namespace }
      @method = @klass.class_methods.find { |class_method| class_method.name == params[:name] }
    elsif params[:module]
      @namespace = @gem.modules.find { |namespace| namespace.qualified_name == params[:module] }
      @method = @namespace.class_methods.find { |class_method| class_method.name == params[:name] }
    end

    render :method
  end
end
