# frozen_string_literal: true

class Layout::GemHeading < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
