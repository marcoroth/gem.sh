# frozen_string_literal: true

class InstanceMethodsList < ViewComponent::Base
  def initialize(instance_methods:, gem:)
    @instance_methods = instance_methods.sort_by(&:qualified_name)
    @gem = gem
  end
end
