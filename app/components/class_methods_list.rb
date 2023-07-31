# frozen_string_literal: true

class ClassMethodsList < ViewComponent::Base
  def initialize(class_methods:, gem:)
    @class_methods = class_methods
    @gem = gem
  end
end
