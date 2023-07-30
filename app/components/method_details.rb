# frozen_string_literal: true

class MethodDetails < ViewComponent::Base
  def initialize(object:, parent:, gem:)
    @object = object
    @parent = parent
    @gem = gem
  end
end
