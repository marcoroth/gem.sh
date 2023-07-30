# frozen_string_literal: true

class Superclass < ViewComponent::Base
  def initialize(superclass:, gem:, title: "Parent")
    @superclass = superclass
    @gem = gem
    @title = title
  end
end
