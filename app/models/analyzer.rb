# frozen_string_literal: true

class Analyzer
  class Visitor < YARP::Visitor
    # This object represents a set of comments being returned from the parser
    # for a given file. It can be used to quickly access a set of comments at
    # a given line number.
    class CommentSet
      attr_reader :comments

      def initialize(comments)
        @comments =
          comments.each_with_object({}) do |comment, indexed|
            indexed[comment.location.start_line] = comment.location.slice[1..].strip
          end
      end

      def for(node)
        start_line = node.location.start_line
        start_line -= 1 unless comments.key?(start_line)
        start_line.downto(1).lazy.take_while { |line| comments.key?(line) }.map(&comments).force
      end
    end

    # This object represents the constant nesting. It internally keeps an array
    # of constant paths, which are arrays of constant names.
    #
    # For example, the constant path for:
    #
    #     module Foo
    #       class Bar::Baz
    #         class Qux
    #         end
    #       end
    #     end
    #
    # would be `[["Foo"], ["Bar", "Baz"], ["Qux"]]`. For the most part, the
    # internal nesting doesn't matter, so most consumers will end up flattening
    # the list of constant names or joining them with "::". There are
    # implications for constant lookup, though, so it's important to maintain
    # those delimiters.
    class ConstantNesting
      ROOT = Object.new

      attr_reader :path

      def initialize
        @path = []
      end

      def initialize_copy(other)
        super
        @path = [*other.path]
      end

      # Updates the nesting for the given constant path for the duration of the
      # given block. Yields the current nesting and the name of the constant.
      def with(node)
        previous_path = path
        next_path = path_for(node)

        @path =
          if next_path == :unprocessable
            next_path
          elsif next_path[0] == ROOT
            next_path[1..]
          else
            [*previous_path, next_path]
          end

        begin
          yield path
        ensure
          @path = previous_path
        end
      end

      private

      # Returns the components of the constant path for the given node.
      def path_for(node)
        case node
        when YARP::ConstantPathNode
          if node.parent
            path_for(node.parent).concat(path_for(node.child))
          else
            [ROOT].concat(path_for(node.child))
          end
        when YARP::ConstantReadNode
          [node.location.slice]
        else
          :unprocessable
        end
      end
    end

    attr_reader :analyzer, :gem, :path, :comment_set, :constant_nesting

    def initialize(analyzer, gem, path, comments)
      super()
      @analyzer = analyzer
      @gem = gem
      @path = path
      @comment_set = CommentSet.new(comments)
      @constant_nesting = ConstantNesting.new
    end

    def visit_class_node(node)
      superclass =
        if node.superclass
          constant_nesting.with(node.superclass) do |constant_path|
            # Constant paths can be any valid Ruby expression, so it's
            # possible we couldn't parse it. In this case we don't know what
            # to do with the superclass, so we'll return nil
            break if constant_path == :unprocessable

            # Otherwise we can process the superclass as a normal constant
            # path.
            *namespace, name = constant_path.flatten

            ClassDefinition.new(
              namespace: namespace,
              name: name,
              qualified_name: constant_path.join("::"),
              location: node.location,
            )
          end
        end

      constant_nesting.with(node.constant_path) do |constant_path|
        constant_path = Array.wrap(constant_path)
        qualified_name = constant_path.join("::")
        reopen = NamespaceReopen.new(path: path, location: node.location, gem: gem)

        if (found = analyzer.classes.find { |clazz| clazz.qualified_name == qualified_name })
          found.defined_files << reopen
        else
          *namespace, name = constant_path.flatten
          found =
            ClassDefinition.new(
              namespace: namespace,
              name: name,
              qualified_name: qualified_name,
              location: node.location,
              superclass: superclass,
              comments: comment_set.for(node),
              defined_files: [reopen],
            )

          analyzer.classes << found
        end

        statements =
          case node.statements
          when nil
            []
          when YARP::StatementsNode
            node.statements.body
          when YARP::BeginNode
            node.statements.statements.body
          else
            raise "Unexpected statements node: #{node.statements.inspect}"
          end

        # Here we're going to look for Kernel#include and Kernel#extend calls.
        # This kind of static analysis is difficult to do without a full type
        # system in place to determine the actual method being called, so we're
        # going to be a little loose here and just look for the method name
        # being called as a top-level statement inside of a class definition.
        statements.each do |statement|
          # Only looking at calls.
          next unless statement.is_a?(YARP::CallNode)

          # Only looking at #include and #extend.
          next unless ["include", "extend"].include?(statement.message)

          # Only looking for calls that have arguments.
          next unless statement.arguments.is_a?(YARP::ArgumentsNode)

          target =
            if statement.message == "include"
              found.included_modules
            else
              found.extended_modules
            end

          statement.arguments.arguments.each do |argument|
            constant_nesting.with(argument) do |argument_constant_path|
              # It's possible to include a module by variable reference, in
              # which case we wouldn't know what kind of module it is. In this
              # case we'll just ignore it.
              next if argument_constant_path == :unprocessable

              # Otherwise we can process the module as a normal constant path.
              namespace, name = find_module(argument_constant_path)
              qualified_name = [*namespace, name].join("::")

              target << ModuleDefinition.new(
                namespace: namespace,
                name: name,
                qualified_name: qualified_name,
                location: argument.location,
                referenced_files: [ConstantReference.new(path: path, location: argument.location)],
              )
            end
          end
        end

        super
      end
    end

    def visit_constant_write_node(node)
      constant_nesting.with(YARP::ConstantReadNode.new(node.name_loc)) do |constant_path|
        analyzer.consts << constant_path.join("::")

        super
      end
    end

    def visit_def_node(node)
      qualified_name = constant_nesting.path.join("::")

      # Note that we're using reverse_each here because it's likely that we're
      # finding the most recently inserted class or module.
      context =
        analyzer.classes.reverse_each.find { |clazz| clazz.qualified_name == qualified_name } ||
        analyzer.modules.reverse_each.find { |mod| mod.qualified_name == qualified_name } ||
        analyzer

      kwargs = {
        name: node.name,
        target: context,
        location: node.location,
        comments: comment_set.for(node),
        defined_files: [path],
      }

      case node.receiver
      when nil
        context.instance_methods << InstanceMethod.new(**kwargs)
      when YARP::SelfNode
        context.class_methods << ClassMethod.new(**kwargs)
      else # rubocop:disable Style/EmptyElse
        # In this case, we don't actually know what to do. The receiver of the
        # method definition is not nil (in which case it would be the current
        # context) and is not self (in which case it would be a class method).
        # For now, we'll ignore it.
      end

      super
    end

    def visit_module_node(node)
      constant_nesting.with(node.constant_path) do |constant_path|
        qualified_name = constant_path.join("::")
        reopen = NamespaceReopen.new(path: path, location: node.location, gem: gem)

        if (found = analyzer.modules.find { |mod| mod.qualified_name == qualified_name })
          found.defined_files << reopen
        else
          *namespace, name = constant_path.flatten

          analyzer.modules << ModuleDefinition.new(
            namespace: namespace,
            name: name,
            qualified_name: qualified_name,
            location: node.location,
            comments: comment_set.for(node),
            defined_files: [reopen],
          )
        end

        super
      end
    end

    private

    # When we're looking at modules that are being included into a class or
    # module, we have to perform our own version of constant lookup like Ruby.
    # For example, when you have:
    #
    #     module Foo
    #       module Bar
    #         include Baz
    #       end
    #     end
    #
    # It's possible that you're including Foo::Bar::Baz, Foo::Baz, or just Baz.
    # To determine which one, Ruby will look for a constant by each of those
    # names in turn. We'll do the same thing here.
    def find_module(constant_path)
      # From our example, this is going to be Foo::Bar::Baz and Foo::Baz.
      qualified_names =
        (constant_path.length - 2).downto(0).map do |index|
          constant_path[0..index].push(constant_path.last).join("::")
        end

      # Now we'll push on Baz.
      qualified_names << Array.wrap(constant_path.last).join("::")

      # Now we'll look for the first one that we find in our list of modules. If
      # we find multiple matches then we'll grab the one with the longest name
      # to replicate Ruby's behavior.
      candidate =
        analyzer
        .modules
        .select { |mod| qualified_names.include?(mod.qualified_name) }
        .max_by { _1.qualified_name.length }

      if candidate
        [candidate.namespace, candidate.name]
      else
        # If we don't find one, then it's possible it was dynamically defined or
        # we got the order of files wrong. In this case it's difficult to know
        # what the correct behavior is. We'll return the most nested possible
        # definition for now.
        *namespace, name = constant_path.flatten
        [namespace, name]
      end
    end
  end

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
    result = YARP.parse(code)
    result.value.accept(Visitor.new(self, @gem, path, result.comments))
    self
  end

  def analyze(path)
    analyze_code(path, File.read(path))
  end
end
