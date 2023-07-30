# frozen_string_literal: true

class InstanceMethodsList < ViewComponent::Base
  def initialize(instance_methods:, gem:)
    @instance_methods = instance_methods.sort_by(&:name)
    @gem = gem
  end
end
