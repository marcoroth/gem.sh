# frozen_string_literal: true

class MethodsList < ViewComponent::Base
  def initialize(methods:, gem:, prefix:)
    @methods = methods.sort_by(&:qualified_name)
    @gem = gem
    @prefix = prefix
  end
end
