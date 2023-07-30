# frozen_string_literal: true

class InstanceMethodsList < ViewComponent::Base
  def initialize(instance_methods:, gem:)
    @instance_methods = instance_methods
    @gem = gem
  end
end
