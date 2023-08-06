# frozen_string_literal: true

class Layout::CodeList < ViewComponent::Base
  def initialize(items:, gem:, title: "Items")
    @items = Array.wrap(items).sort_by { |item| item.try(:title) || item.to_s }
    @gem = gem
    @title = title
  end
end
