class GemsController < ApplicationController
  before_action :set_gem, except: :index
  before_action :set_namespaces, except: :index

  def index
    @gems = Gem::Specification.all.sort_by(&:name)
  end

  def show
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def namespace
    @namespace = @gem.modules.find { |namespace| namespace.qualified_name == params[:module] }
    @classes = @gem.classes.select { |namespace| namespace.namespace == params[:module] }

    redirect_to gem_version_path(@gem.name, @gem.version) if @namespace.nil?
  end

  def klass
    @klass = @gem.classes.find { |klass| klass.qualified_name == params[:class] }
    @namespace = @gem.modules.find { |namespace| namespace.qualified_name == @klass.namespace }
  end

  def instance_method
    if params[:class]
      @klass = @gem.classes.find { |klass| klass.qualified_name == params[:class] }
      @namespace = @gem.modules.find { |namespace| namespace.qualified_name == @klass.namespace }
      @method = @klass.instance_methods.find { |instance_method| instance_method.name == params[:name] }
    elsif params[:module]
      @namespace = @gem.modules.find { |namespace| namespace.qualified_name == params[:module] }
      @method = @namespace.instance_methods.find { |instance_method| instance_method.name == params[:name] }
    else
      @namespace = @gem.info.analyzer
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
    else
      @namespace = @gem.info.analyzer
      @method = @namespace.class_methods.find { |class_method| class_method.name == params[:name] }
    end

    render :method
  end

  private

  def set_gem
    @gem = Gemspec.find(params[:gem], params[:version])

    redirect_to gems_path if @gem.nil?

    @version = @gem.version

  rescue StandardError
    redirect_to gems_path
  end

  def set_namespaces
    @namespaces = @gem.modules.select { |namespace| namespace.namespace.split("::").count <= 1 }
  end
end
