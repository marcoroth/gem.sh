# frozen_string_literal: true

require "syntax_tree"

class Visitor < SyntaxTree::Visitor
  attr_accessor :current_path

  def initialize(analyzer)
    super()

    @analyzer = analyzer
    @namespace = []
    @comments = []
    @current_class = nil
    @current_path = nil
  end

  def visit_class(node)
    namespace = @namespace.map(&:name).compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].compact_blank.join("::")

    class_definition = @analyzer.classes.find { |m| m.qualified_name == qualified_name }

    reopen = NamespaceReopen.new(
      path: current_path,
      location: node.location,
    )

    if node.superclass
      superclass_namespace = node.superclass.try(:parent).try(:value).try(:value)
      superclass_name = node.superclass.try(:constant).try(:value) || node.superclass.try(:value).try(:value)
      superclass_qualified_name = [superclass_namespace, superclass_name].compact_blank.join("::")

      superclass_definition = ClassDefinition.new(
        namespace: superclass_namespace,
        name: superclass_name,
        qualified_name: superclass_qualified_name,
        location: node.location,
        # node: node.superclass
      )
    else
      superclass_definition = ClassDefinition.new(
        name: "Object",
        qualified_name: "Object",
      )
    end

    if class_definition.nil?
      class_definition = ClassDefinition.new(
        namespace: namespace,
        name: name,
        qualified_name: qualified_name,
        location: node.location,
        # node: node,
        superclass: superclass_definition,
        comments: @comments,
        defined_files: [reopen],
      )
      @analyzer.classes << class_definition
    else
      class_definition.defined_files << reopen
    end

    @comments = []
    @current_class = class_definition

    super

    @current_class = nil
  end

  def visit_module(node)
    namespace = @namespace.map(&:name).compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].compact_blank.join("::")

    module_definition = @analyzer.modules.find { |m| m.qualified_name == qualified_name }
    reopen = NamespaceReopen.new(
      path: current_path,
      location: node.location,
    )

    if module_definition.nil?
      module_definition = ModuleDefinition.new(
        namespace: namespace,
        name: name,
        qualified_name: qualified_name,
        location: node.location,
        # node: node,
        comments: @comments,
        defined_files: [reopen],
      )
      @analyzer.modules << module_definition
    else
      module_definition.defined_files << reopen
    end

    @comments = []
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

    super

    if @current_class
      parent = @current_class
    elsif @namespace.any?
      parent = @namespace.last
    else
      parent = @analyzer
    end

    method_definition_args = {
      name: method_name,
      target: parent,
      location: node.location,
      # node: node,
      comments: @comments,
      defined_files: [current_path],
    }

    if target == "self"
      parent.class_methods << ClassMethod.new(**method_definition_args)
    else
      parent.instance_methods << InstanceMethod.new(**method_definition_args)
    end

    @comments = []
  end

  def visit_comment(node)
    @comments << node
  end

  def visit_command(node)
    name = node.message.value

    return if @current_class.nil?

    reference = ConstantReference.new(
      path: current_path,
      location: node.location,
    )

    if name == "include"
      node.arguments.parts.each do |part|
        module_namespace = part.try(:parent).try(:value).try(:value)
        module_name = part.try(:constant).try(:value) || part.try(:value).try(:value)
        module_qualified_name = [module_namespace, module_name].compact_blank.join("::")

        @current_class.included_modules << ModuleDefinition.new(
          namespace: module_namespace,
          name: module_name,
          qualified_name: module_qualified_name,
          location: node.location,
          # node: part,
          referenced_files: [reference],
        )
      end
    end

    if name == "extend"
      node.arguments.parts.each do |part|
        module_namespace = part.try(:parent).try(:value).try(:value)
        module_name = part.try(:constant).try(:value) || part.try(:value).try(:value)
        module_qualified_name = [module_namespace, module_name].compact_blank.join("::")

        @current_class.extended_modules << ModuleDefinition.new(
          namespace: module_namespace,
          name: module_name,
          qualified_name: module_qualified_name,
          location: node.location,
          # node: part,
          referenced_files: [reference],
        )
      end
    end

    super
  end
end
