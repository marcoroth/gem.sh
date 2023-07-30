# frozen_string_literal: true

class GemMetadata < ViewComponent::Base
  def initialize(gem:)
    @gem = gem
  end
end
