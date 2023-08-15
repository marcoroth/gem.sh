# frozen_string_literal: true

class GemsController < ApplicationController
  before_action :set_gem, except: [:index, :search]
  before_action :set_target, only: [:instance_method, :class_method]

  rescue_from "GemNotFoundError", "Gems::NotFound" do |exception|
    redirect_to gems_path, notice: exception.message
  end

  rescue_from "GemConstantNotFoundError" do |exception|
    redirect_to gem_version_path(@gem.name, @gem.version), notice: exception.message
  end

  def index
    @gems = Gem::Specification.all.sort_by(&:name)
  end

  def show
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def mod
    @module = find_module!(params[:module])
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @module.qualified_name }
    @modules = @gem.modules.select { |mod| mod.qualified_namespace == @module.qualified_name }

    render :module
  end

  def klass
    @klass = find_class!(params[:class])
    @namespace = find_namespace(@klass.qualified_namespace)
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @klass.qualified_name }
  end

  def instance_method
    @method = @target.instance_methods.find { |instance_method| instance_method.name == params[:name] }

    raise(GemConstantNotFoundError, "Instance method '#{params[:name]}' not found on '#{@target.try(:qualified_name)}'") if @method.nil?

    render :method
  end

  def class_method
    @method = @target.class_methods.find { |class_method| class_method.name == params[:name] }

    raise(GemConstantNotFoundError, "Class method '#{params[:name]}' not found on '#{@target.try(:qualified_name)}'") if @method.nil?

    render :method
  end

  def source
    SourceFile.new(file: params[:file], gem: @gem).tap do |file|
      @file = file if file.exist?
    end
  end

  private

  def find_class(name)
    @gem.classes.find { |klass| klass.qualified_name == name }
  end

  def find_class!(name)
    find_class(name) || raise(GemConstantNotFoundError, "Couldn't find class '#{name}'")
  end

  def find_module(name)
    @gem.modules.find { |mod| mod.qualified_name == name }
  end

  def find_module!(name)
    find_module(name) || raise(GemConstantNotFoundError, "Couldn't find module '#{name}'")
  end

  def find_namespace(name)
    find_module(name) || find_class(name)
  end

  def find_namespace!(name)
    find_namespace(name) || raise(GemConstantNotFoundError, "Couldn't find namespace '#{name}'")
  end

  def set_gem
    @gem = GemSpec.find(params[:gem], params[:version]) || raise(GemNotFoundError.new(params[:gem], params[:version]))
  end

  def set_target
    if params[:class]
      @target = find_class!(params[:class])
      @namespace = find_namespace(@target.qualified_namespace)
    elsif params[:module]
      @target = find_module!(params[:module])
    else
      @target = @gem.info.analyzer
    end
  end
end
