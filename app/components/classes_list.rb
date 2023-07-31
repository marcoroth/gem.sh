# frozen_string_literal: true

class ClassesList < ViewComponent::Base
  def initialize(classes:, gem:)
    @classes = classes
    @gem = gem
  end
end
