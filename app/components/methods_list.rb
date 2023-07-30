# frozen_string_literal: true

class MethodsList < ViewComponent::Base
  def initialize(con_methods:, gem:, prefix:)
    @con_methods = con_methods.sort_by(&:name)
    @gem = gem
    @prefix = prefix
  end
end
