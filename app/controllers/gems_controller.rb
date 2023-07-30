class GemsController < ApplicationController
  def index
    @gems = Gem::Specification.all.sort_by { |gem| gem.name }
  end

  def show
    @gem = Gemspec.find(params[:gem])
    @namespaces = @gem.modules.select { |namespace| namespace.namespace.split("::").count <= 1 }
    @classes = @gem.classes
    @instance_methods = @gem.instance_methods
    @class_methods = @gem.class_methods
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def namespace
    @gem = Gemspec.find(params[:gem])
    @namespace = @gem.modules.find { |namespace| namespace.qualified_name == params[:name] }
    @namespaces = @gem.modules.select { |namespace| namespace.namespace == params[:name] }
    @classes = @gem.classes.select { |namespace| namespace.namespace == params[:name] }

    @instance_methods = Array.wrap(@namespace && @namespace.instance_methods)
    @class_methods = Array.wrap(@namespace && @namespace.class_methods)

    render :show
  end

  def klass
    @gem = Gemspec.find(params[:gem])
    @klass = @gem.classes.find { |klass| klass.qualified_name == params[:name] }
    @namespace = @gem.modules.find { |namespace| namespace.qualified_name == @klass.namespace }
    @instance_methods = @klass.instance_methods
    @class_methods = @klass.class_methods
  end

  def instance_method
    @gem = Gemspec.find(params[:gem])

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
    @gem = Gemspec.find(params[:gem])

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
