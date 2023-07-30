# frozen_string_literal: true

require "syntax_tree"

class Visitor < SyntaxTree::Visitor
  def initialize(analyzer)
    @analyzer = analyzer
    @namespace = []
    @current_class = nil
  end

  def visit_class(node)
    namespace = @namespace.map(&:name).compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].reject(&:blank?).join("::")

    class_definition = @analyzer.classes.find { |m| m.qualified_name == qualified_name }

    if class_definition.nil?
      class_definition = ClassDefinition.new(namespace: namespace, name: name, qualified_name: qualified_name, node: node)
      @analyzer.classes << class_definition
    end

    @current_class = class_definition

    super

    @current_class = nil
  end

  def visit_module(node)
    namespace = @namespace.map(&:name).compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].reject(&:blank?).join("::")

    module_definition = @analyzer.modules.find { |m| m.qualified_name == qualified_name }

    if module_definition.nil?
      module_definition = ModuleDefinition.new(namespace: namespace, name: name, qualified_name: qualified_name, node: node)
      @analyzer.modules << module_definition
    end

    @namespace << module_definition

    super

    @namespace.pop
  end

  def visit_const(node)
    @analyzer.consts << [*@namespace.map(&:name), node.value].compact.join("::")

    super
  end

  def visit_def(node)
    method_name = node.name.value
    target = node.target&.value&.value

    if @current_class
      if target == "self"
        @current_class.class_methods << ClassMethod.new(name: method_name, target: @current_class, node: node)
      else
        @current_class.instance_methods << InstanceMethod.new(name: method_name, target: @current_class, node: node)
      end
    elsif @namespace.any?
      if target == "self"
        @namespace.last.class_methods << ClassMethod.new(name: method_name, target: @namespace.last, node: node)
      else
        @namespace.last.instance_methods << InstanceMethod.new(name: method_name, target: @namespace.last, node: node)
      end
    else
      if target == "self"
        @analyzer.class_methods << ClassMethod.new(name: method_name, target: @current_class, node: node)
      else
        @analyzer.instance_methods << InstanceMethod.new(name: method_name, target: @current_class, node: node)
      end
    end

    super
  end

  # def visit_program(node)
  #   puts node.class
  #
  #   super
  # end

  # def visit_defined(node)
  #   puts node.class
  #
  #   super
  # end

  # def visit_command(node)
  #   @analyzer.instance_methods << node.message.value
  #
  #   super
  # end

  # def visit_call(node)
  #   puts node.inspect
  #   super
  # end

  # def visit_vcall(node)
  #   @analyzer.locals << node.value.value
  #
  #   super
  # end
end
