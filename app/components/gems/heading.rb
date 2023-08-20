# frozen_string_literal: true

class Gems::Heading < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
