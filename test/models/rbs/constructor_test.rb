# frozen_string_literal: true

require "test_helper"

module RBS
  class ConstructorTest < ActiveSupport::TestCase
    def setup
      @gem = GemSpec.find("nokogiri", "1.15.0")
      @class = @gem.find_class("Nokogiri::XML::Document")
      @method = @class.find_method("initialize")
    end

    test "initialize's return_value is void" do
      assert_nil @method.rbs_signature(@gem)
      assert_equal "def initialize: () -> void", @method.rbs_signature(@gem, require_samples: false)

      @method.clear_sample_cache!

      FactoryBot.create(
        :type_sample,
        gem_name: "nokogiri",
        gem_version: "1.15.0",
        receiver: "Nokogiri::XML::Document",
        method_name: "initialize",
        parameters: [],
        return_value: nil,
      )

      @method = @class.find_method("initialize")

      assert_equal "def initialize: () -> void", @method.rbs_signature(@gem)
      assert_equal "def initialize: () -> void", @method.rbs_signature(@gem, require_samples: false)
    end
  end
end
