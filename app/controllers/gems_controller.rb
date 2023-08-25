# frozen_string_literal: true

class GemsController < ApplicationController
  before_action :set_gem, except: [:index, :search]
  before_action :set_target, only: [:instance_method, :class_method]
  # before_action :set_namespaces, except: [:index, :search]
  before_action :set_guides

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
    @getting_started = [
      OpenStruct.new(title: "Installation", url: Router.gem_readme_path(@gem.name, @gem.version), description: "Learn more about how to install and configure the gem", icon: "arrow-down-tray"),
      OpenStruct.new(title: "Documentation", url: Router.gem_guides_path(@gem.name, @gem.version), description: "Learn more about the details", icon: "book-open"),
      OpenStruct.new(title: "Guides", url: Router.gem_guides_path(@gem.name, @gem.version), description: "Learn more about the gem in the written guides", icon: "document-text"),
      OpenStruct.new(title: "Reference", url: Router.gem_reference_path(@gem.name, @gem.version), description: "Learn more about the classes and modules", icon: "code-bracket"),
    ]
  end

  def search
    @result = GemSearch.search(params[:name])
  end

  def mod
    @module = @gem.find_module!(params[:module])
    @modules = @gem.modules.select { |mod| mod.qualified_namespace == @module.qualified_name }
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @module.qualified_name }

    render :module
  end

  def klass
    @class = @gem.find_class!(params[:class])
    @classes = @gem.classes.select { |klass| klass.qualified_namespace == @class.qualified_name }
    @namespace = @gem.find_namespace(@class.qualified_namespace)

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
    @samples = Types::Sample
               .group(:gem_name, :gem_version, :receiver, :method_name)
               .where(gem_name: @gem.name)
               .where("gem_version LIKE ?", "#{@gem.version.to_s.split('-').first}%")
               .order(count: :desc)
               .count
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

  def set_guides
    @guides = [
      "Basics",
      "Migrations",
      "Validations",
      "Callbacks",
      "Authentication",
      "Persistence",
      "Patterns",
      "Deployment",
      "Troubleshooting",
    ]
  end
end
