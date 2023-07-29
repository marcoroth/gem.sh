# frozen_string_literal: true

require "syntax_tree"

class Visitor < SyntaxTree::Visitor
  def initialize(analyzer)
    @analyzer = analyzer
  end

  def visit_module(node)
    @analyzer.modules << node.constant.constant.value

    super
  end

  def visit_const(node)
    @analyzer.consts << node.value

    super
  end
end
