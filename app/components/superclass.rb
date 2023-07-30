# frozen_string_literal: true

class Superclass < ViewComponent::Base
  def initialize(superclass:, gem:)
    @superclass = superclass
    @gem = gem
  end
end
