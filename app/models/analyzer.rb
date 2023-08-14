# frozen_string_literal: true

require "syntax_tree"

class Analyzer
  attr_accessor :classes, :modules, :consts, :instance_methods, :class_methods

  def self.call(source)
    new.analyze(source)
  end

  def initialize(gem = nil)
    @gem = gem

    @classes = Set.new
    @modules = Set.new
    @consts = Set.new
    @instance_methods = Set.new
    @class_methods = Set.new

    @visitor = Visitor.new(self, gem)
  end

  def qualified_name
    "global"
  end

  def object_name
    "global"
  end

  def url(gem)
    Router.gem_version_path(gem.name, gem.version)
  end

  def to_s
    "global"
  end

  def analyze_code(path, code)
    program = SyntaxTree.parse(code)

    @visitor.current_path = path
    @visitor.visit(program)

    self
  rescue SyntaxTree::Parser::ParseError, NoMethodError => e
    Rails.logger.debug e.inspect

    self
  end

  def analyze(path)
    analyze_code(path, SyntaxTree.read(code))
  end
end
