# frozen_string_literal: true

require "test_helper"

module RBS
  class NilableTest < ActiveSupport::TestCase
    def setup
      @gem = GemSpec.find("activerecord", "7.0.7")
      @module = @gem.find_class("ActiveRecord::ConnectionAdapters::PoolManager")
      @method = @module.find_method("pool_configs")
    end

    test "optional positional arguments as nilable type" do
      FactoryBot.create(
        :type_sample,
        gem_name: "activerecord",
        gem_version: "7.0.7",
        receiver: "ActiveRecord::ConnectionAdapters::PoolManager",
        method_name: "pool_configs",
        parameters: [
          ["role", "opt", "NilClass"]
        ],
        return_value: nil
      )

      assert_equal "def pool_configs: (?nil role) -> untyped", @method.rbs_signature(@gem)

      FactoryBot.create(
        :type_sample,
        gem_name: "activerecord",
        gem_version: "7.0.7",
        receiver: "ActiveRecord::ConnectionAdapters::PoolManager",
        method_name: "pool_configs",
        parameters: [
          ["role", "opt", "String"]
        ],
        return_value: nil
      )

      assert_equal "def pool_configs: (?String? role) -> untyped", @method.rbs_signature(@gem)
    end
  end
end
