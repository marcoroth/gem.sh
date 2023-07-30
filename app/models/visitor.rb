# frozen_string_literal: true

require "syntax_tree"

class Visitor < SyntaxTree::Visitor
  def initialize(analyzer)
    @analyzer = analyzer
    @namespace = []
    @current_class = nil
  end

  def visit_class(node)
    namespace = @namespace.compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].reject(&:blank?).join("::")

    @current_class = OpenStruct.new(namespace: namespace, name: name, qualified_name: qualified_name, instance_methods: [], class_methods: [])

    @analyzer.classes << @current_class

    super

    @current_class = nil
  end

  def visit_module(node)
    namespace = @namespace.compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].reject(&:blank?).join("::")

    @analyzer.modules << OpenStruct.new(namespace: namespace, name: name, qualified_name: qualified_name)

    @namespace << name

    super

    @namespace.pop
  end

  def visit_const(node)
    @analyzer.consts << [*@namespace, node.value].compact.join("::")

    super
  end

  def visit_def(node)
    method_name = node.name.value
    target = node.target&.value&.value

    if @current_class
      if target == "self"
        @current_class.class_methods << method_name
      else
        @current_class.instance_methods << method_name
      end
    else
      if target == "self"
        @analyzer.class_methods << method_name
      else
        @analyzer.instance_methods << method_name
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
