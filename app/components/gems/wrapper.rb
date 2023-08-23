# frozen_string_literal: true

class Gems::Wrapper < ViewComponent::Base
  def initialize(gem:, modules:, classes:, class_methods:, instance_methods:)
    @gem = gem
    @modules = modules
    @classes = classes
    @class_methods = class_methods
    @instance_methods = instance_methods
  end
end
