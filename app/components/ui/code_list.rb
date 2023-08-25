# frozen_string_literal: true

class UI::CodeList < ViewComponent::Base
  def initialize(items:, gem:, title: "Items")
    items = items.to_a if items.is_a?(Set)

    @items = Array.wrap(items).sort_by { |item| item.try(:title) || item.to_s }
    @gem = gem
    @title = title
  end
end
