# frozen_string_literal: true

class ConstantDefinition < ViewComponent::Base
  def initialize(definition:, gem:, name: nil, title: "Parent")
    @definition = definition
    @name = name
    @gem = gem
    @title = title
  end

  def name
    @name || @definition.qualified_name
  end

  def link?
    @definition && @definition.respond_to?(:url)
  end
end
