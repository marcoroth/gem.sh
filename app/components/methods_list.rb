# frozen_string_literal: true

class MethodsList < ViewComponent::Base
  def initialize(methods:, gem:, prefix:)
    @methods = methods
    @gem = gem
    @prefix = prefix
  end
end
