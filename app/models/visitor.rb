# frozen_string_literal: true

require "syntax_tree"

class Visitor < SyntaxTree::Visitor
  attr_accessor :current_path

  def initialize(analyzer, gem)
    super()

    @analyzer = analyzer
    @gem = gem

    @modules = []
    @comments = []
    @namespace = []
    @classes = []

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
      gem: @gem,
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
    @classes << class_definition
    @namespace << class_definition

    super

    @namespace.pop
    @classes.pop
  end

  def visit_module(node)
    namespace = @namespace.map(&:name).compact.join("::")
    name = node.constant.constant.value
    qualified_name = [namespace, name].compact_blank.join("::")

    module_definition = @analyzer.modules.find { |m| m.qualified_name == qualified_name }
    reopen = NamespaceReopen.new(
      path: current_path,
      location: node.location,
      gem: @gem,
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
    @modules << module_definition
    @namespace << module_definition

    super

    @namespace.pop
    @modules.pop
  end

  def visit_const(node)
    @analyzer.consts << [*@modules.map(&:name), node.value].compact.join("::")

    super
  end

  def visit_def(node)
    method_name = node.name.value
    target = node.target&.value&.value

    super

    context = if @classes.any?
                @classes.last
              elsif @modules.any?
                @modules.last
              else
                inferred_context_for(target)
              end

    method_definition_args = {
      name: method_name,
      target: context,
      location: node.location,
      # node: node,
      comments: @comments,
      defined_files: [current_path],
    }

    # the method can define itself onto "self", or can have a target of a constant
    # to define the class there. see #inferred_context_for for more
    if target.nil?
      context.instance_methods << InstanceMethod.new(**method_definition_args)
    else
      context.class_methods << ClassMethod.new(**method_definition_args)
    end

    @comments = []
  end

  def visit_comment(node)
    @comments << node
  end

  def visit_command(node)
    return if @classes.none?

    klass = @classes.last
    name = node.message.value

    reference = ConstantReference.new(
      path: current_path,
      location: node.location,
    )

    if ["include", "extend"].include?(name)
      modules = (name == "include") ? klass.included_modules : klass.extended_modules

      node.arguments.parts.each do |part|
        module_namespace = part.try(:parent).try(:value).try(:value)
        module_name = part.try(:constant).try(:value) || part.try(:value).try(:value)
        module_qualified_name = [module_namespace, module_name].compact_blank.join("::")

        modules << ModuleDefinition.new(
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


  private

  # handle method names like `Skiptrace.current_bindings` where the constant
  # wasn't already visited
  def inferred_context_for(target)
    if existing = @analyzer.modules.detect { |name| name.qualified_name == target }
      if prev = @modules.find { |mod| mod.qualified_name == existing.qualified_name }
        return prev
      else
        @modules << existing
        @namespace << existing
        return existing
      end
    elsif existing = @analyzer.classes.detect { |name| name.qualified_name == target }
      if prev = @classes.find { |klass| klass.qualified_name == existing.qualified_name }
        return prev
      else
        @classes << existing
        return existing
      end
    end

    @analyzer
  end

end
