# frozen_string_literal: true

require "syntax_tree"

class Visitor < SyntaxTree::Visitor
  def initialize(analyzer)
    @analyzer = analyzer
    @namespace = []
  end

  def visit_class(node)
    namespace = @namespace.compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].reject(&:blank?).join("::")

    @analyzer.classes << OpenStruct.new(namespace: namespace, name: name, qualified_name: qualified_name)

    super
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
end
