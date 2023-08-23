# frozen_string_literal: true

class UI::Card < ViewComponent::Base
  renders_one :badge, UI::Badge

  def initialize(title:, description:)
    @title = title
    @description = description
  end
end
