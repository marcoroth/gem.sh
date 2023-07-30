# frozen_string_literal: true

class Layout::Card < ViewComponent::Base
  def initialize(title:, description:, label:)
    @title = title
    @description = description
    @label = label
  end
end
