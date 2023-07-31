# frozen_string_literal: true

class Layout::Card < ViewComponent::Base
  renders_one :badge, Layout::Badge

  def initialize(title:, description:)
    @title = title
    @description = description
  end
end
