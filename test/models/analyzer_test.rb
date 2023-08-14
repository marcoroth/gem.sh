# frozen_string_literal: true

require "test_helper"

class AnalyzerTest < ActiveSupport::TestCase
  test "classes" do
    analyzer = Analyzer.new

    analyzer.analyze_code("test.rb", <<~RUBY)
      # comment1
      # comment2
      class Foo
      end
    RUBY

    assert_equal 1, analyzer.classes.size

    clazz = analyzer.classes.first
    assert_equal "Foo", clazz.name
    assert_equal 2, clazz.comments.length
    assert_equal 1, clazz.defined_files.length

    defined_file = clazz.defined_files.first
    assert_equal "test.rb", defined_file.path
  end

  test "classes with superclass" do
    analyzer = Analyzer.new

    analyzer.analyze_code("test.rb", <<~RUBY)
      class Foo < Bar
      end
    RUBY

    assert_equal 1, analyzer.classes.size

    clazz = analyzer.classes.first
    assert_not_nil clazz.superclass

    assert_equal "Bar", clazz.superclass.name
  end

  test "classes redefined" do
    analyzer = Analyzer.new

    analyzer.analyze_code("foo.rb", <<~RUBY)
      class Foo
      end
    RUBY

    analyzer.analyze_code("bar.rb", <<~RUBY)
      class Foo
      end
    RUBY

    assert_equal 1, analyzer.classes.length
    assert_equal 2, analyzer.classes.first.defined_files.length
  end

  test "modules" do
    analyzer = Analyzer.new

    analyzer.analyze_code("test.rb", <<~RUBY)
      # comment1
      # comment2
      module Foo
      end
    RUBY

    assert_equal 1, analyzer.modules.size

    mod = analyzer.modules.first
    assert_equal "Foo", mod.name
    assert_equal 2, mod.comments.length
    assert_equal 1, mod.defined_files.length

    defined_file = mod.defined_files.first
    assert_equal "test.rb", defined_file.path
  end

  test "modules redefined" do
    analyzer = Analyzer.new

    analyzer.analyze_code("foo.rb", <<~RUBY)
      module Foo
      end
    RUBY

    analyzer.analyze_code("bar.rb", <<~RUBY)
      module Foo
      end
    RUBY

    assert_equal 1, analyzer.modules.length
    assert_equal 2, analyzer.modules.first.defined_files.length
  end

  test "instance methods" do
    analyzer = Analyzer.new

    analyzer.analyze_code("test.rb", <<~RUBY)
      # comment1
      # comment2
      def foo
      end
    RUBY

    assert_equal 1, analyzer.instance_methods.length

    instance_method = analyzer.instance_methods.first
    assert_equal "foo", instance_method.name
    assert_equal 2, instance_method.comments.length
  end

  test "class methods" do
    analyzer = Analyzer.new

    analyzer.analyze_code("test.rb", <<~RUBY)
      # comment1
      # comment2
      def self.foo
      end
    RUBY

    assert_equal 1, analyzer.class_methods.length

    class_method = analyzer.class_methods.first
    assert_equal "foo", class_method.name
    assert_equal 2, class_method.comments.length
  end

  test "constants" do
    analyzer = Analyzer.new

    analyzer.analyze_code("test.rb", <<~RUBY)
      # comment1
      # comment2
      FOO = 1
    RUBY

    assert_equal 1, analyzer.consts.length
    assert_equal "FOO", analyzer.consts.first
  end
end
