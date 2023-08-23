# frozen_string_literal: true

class UI::Heading < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
