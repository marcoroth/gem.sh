# frozen_string_literal: true

require "syntax_tree"

class Analyzer
  attr_accessor :classes, :modules, :consts, :instance_methods, :class_methods

  def self.call(source)
    new.analyze(source)
  end

  def initialize
    @classes = Set.new
    @modules = Set.new
    @consts = Set.new
    @instance_methods = Set.new
    @class_methods = Set.new

    @visitor = Visitor.new(self)
  end

  def qualified_name
    "global"
  end

  def object_name
    "global"
  end

  def to_s
    "global"
  end

  def analyze(path)
    code = File.read(path)
    program = SyntaxTree.parse(code)

    @visitor.current_path = path
    @visitor.visit(program)

    self
  rescue SyntaxTree::Parser::ParseError, NoMethodError => e
    puts e.inspect

    self
  end
end
