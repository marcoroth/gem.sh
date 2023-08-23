# frozen_string_literal: true

require "test_helper"

module RBS
  class RBSTest < ActiveSupport::TestCase
    def setup
      @gem = GemSpec.find("railties", "7.0.6")
      @module = @gem.find_module("Rails")
      @method = @module.find_method("env")
    end

    test "with no samples" do
      assert_nil @method.rbs_signature(@gem)
      assert_nil @method.rbs_signature(@gem, require_samples: true)
      assert_equal "def env: () -> untyped", @method.rbs_signature(@gem, require_samples: false)

      assert_nil @module.rbs_signature(@gem)

      assert_equal <<~RBS, @module.rbs_signature(@gem, require_samples: false)
        # sig/rails.rbs

        module Rails
          def self.gem_version: () -> untyped
          def self.version: () -> untyped
          def application: () -> untyped
          def autoloaders: () -> untyped
          def backtrace_cleaner: () -> untyped
          def configuration: () -> untyped
          def env: () -> untyped
          def env=: () -> untyped
          def error: () -> untyped
          def groups: () -> untyped
          def public_path: () -> untyped
          def root: () -> untyped
        end
      RBS
    end

    test "with one sample" do
      FactoryBot.create(
        :type_sample,
        gem_name: "railties",
        gem_version: "7.0.6",
        receiver: "Rails",
        method_name: "env",
        parameters: [],
        return_value: "String",
      )

      assert_equal "def env: () -> String", @method.rbs_signature(@gem)

      assert_equal <<~RBS, @module.rbs_signature(@gem)
        # sig/rails.rbs

        module Rails
          def env: () -> String
        end
      RBS

      assert_equal <<~RBS, @module.rbs_signature(@gem, require_samples: false)
        # sig/rails.rbs

        module Rails
          def self.gem_version: () -> untyped
          def self.version: () -> untyped
          def application: () -> untyped
          def autoloaders: () -> untyped
          def backtrace_cleaner: () -> untyped
          def configuration: () -> untyped
          def env: () -> String
          def env=: () -> untyped
          def error: () -> untyped
          def groups: () -> untyped
          def public_path: () -> untyped
          def root: () -> untyped
        end
      RBS
    end
  end
end
