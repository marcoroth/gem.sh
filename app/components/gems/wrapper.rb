# frozen_string_literal: true

class Gems::Wrapper < ViewComponent::Base
  def initialize(gem:, namespaces:, classes:, class_methods:, instance_methods:)
    @gem = gem
    @namespaces = namespaces
    @classes = classes
    @class_methods = class_methods
    @instance_methods = instance_methods
  end
end
