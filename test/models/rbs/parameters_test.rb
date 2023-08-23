# frozen_string_literal: true

require "test_helper"

module RBS
  class ParametersTest < ActiveSupport::TestCase
    def setup
      @gem = GemSpec.find("nokogiri", "1.15.0")
      @class = @gem.find_class("Nokogiri::XML::Document")
      @method = @class.find_method("parse")
    end

    test "positional arguments and optional positional arguments" do
      FactoryBot.create(
        :type_sample,
        gem_name: "nokogiri",
        gem_version: "1.15.0",
        receiver: "Nokogiri::XML::Document",
        method_name: "parse",
        parameters: [
          ["string_or_io", "req", "String"],
          ["url", "opt", "NilClass"],
          ["encoding", "opt", "String"],
          ["options", "opt", "Integer"],
        ],
        return_value: "Nokogiri::XML::Document",
      )

      assert_equal "def parse: (String string_or_io, ?nil url, ?String encoding, ?Integer options) -> Nokogiri::XML::Document", @method.rbs_signature(@gem)

      assert_equal <<~RBS, @class.rbs_signature(@gem)
        # sig/nokogiri/xml/document.rbs

        class Nokogiri::XML::Document < Nokogiri::XML::Nokogiri::XML::Node
          def parse: (String string_or_io, ?nil url, ?String encoding, ?Integer options) -> Nokogiri::XML::Document
        end
      RBS

      assert_equal <<~RBS, @class.rbs_signature(@gem, require_samples: false)
        # sig/nokogiri/xml/document.rbs

        class Nokogiri::XML::Document < Nokogiri::XML::Nokogiri::XML::Node
          def add_child: () -> untyped
          def collect_namespaces: () -> untyped
          def create_cdata: () -> untyped
          def create_comment: () -> untyped
          def create_element: () -> untyped
          def create_text_node: () -> untyped
          def deconstruct_keys: () -> untyped
          def decorate: () -> untyped
          def decorators: () -> untyped
          def document: () -> untyped
          def empty_doc?: () -> untyped
          def fragment: () -> untyped
          def initialize: () -> void
          def inspect_attributes: () -> untyped
          def name: () -> untyped
          def namespaces: () -> untyped
          def parse: (String string_or_io, ?nil url, ?String encoding, ?Integer options) -> Nokogiri::XML::Document
          def slop!: () -> untyped
          def validate: () -> untyped
          def xpath_doctype: () -> untyped
        end
      RBS
    end
  end
end
