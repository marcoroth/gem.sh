# frozen_string_literal: true

class Layout::Subheading < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
