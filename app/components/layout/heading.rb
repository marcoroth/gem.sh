# frozen_string_literal: true

class Layout::Heading < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
