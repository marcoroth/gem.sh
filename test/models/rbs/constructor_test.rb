# frozen_string_literal: true

require "test_helper"

module RBS
  class ConstructorTest < ActiveSupport::TestCase
    def setup
      @gem = GemSpec.find("nokogiri", "1.15.0")
      @module = @gem.find_class("Nokogiri::XML::Document")
      @method = @module.find_method("initialize")
    end

    test "initialize's return_value is void" do
      assert_nil @method.rbs_signature(@gem)
      assert_equal "def initialize: () -> void", @method.rbs_signature(@gem, require_samples: false)

      FactoryBot.create(
        :type_sample,
        gem_name: "nokogiri",
        gem_version: "1.15.0",
        receiver: "Nokogiri::XML::Document",
        method_name: "initialize",
        parameters: [],
        return_value: nil,
      )

      assert_equal "def initialize: () -> void", @method.rbs_signature(@gem)
      assert_equal "def initialize: () -> void", @method.rbs_signature(@gem, require_samples: false)
    end
  end
end
