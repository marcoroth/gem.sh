# frozen_string_literal: true

class ClassesList < ViewComponent::Base
  def initialize(classes:, gem:)
    @classes = classes.sort_by(&:name)
    @gem = gem
  end
end
