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
    @module = @gem.find_module!(params[:module])
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @module.qualified_name }
    @modules = @gem.modules.select { |mod| mod.qualified_namespace == @module.qualified_name }

    render :module
  end

  def klass
    @klass = @gem.find_class!(params[:class])
    @namespace = @gem.find_namespace(@klass.qualified_namespace)
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @klass.qualified_name }

    render :class
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

  def types
    @samples = ::Types::Sample.group(:gem_name, :gem_version, :receiver, :method_name).where(gem_name: @gem.name).order(count: :desc).count
  rescue StandardError
    @samples = []
  end

  def rbs
    require_samples = params[:require_samples].present?
    signature = @gem.rbs_signature(require_samples:)

    filename = "#{@gem.name}-#{@gem.version}-#{require_samples ? 'only-samples' : 'complete'}.rbs"

    if params[:download].present?
      send_data signature, type: "application/x-ruby", disposition: "attachment", filename: filename
    else
      render plain: signature
    end
  end

  private

  def set_gem
    @gem = GemSpec.find(params[:gem], params[:version]) || raise(GemNotFoundError.new(params[:gem], params[:version]))
  end

  def set_target
    if params[:class]
      @target = @gem.find_class!(params[:class])
      @namespace = @gem.find_namespace(@target.qualified_namespace)
    elsif params[:module]
      @target = @gem.find_module!(params[:module])
    else
      @target = @gem.info.analyzer
    end
  end
end
