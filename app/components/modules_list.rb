# frozen_string_literal: true

class ModulesList < ViewComponent::Base
  def initialize(modules:, gem:, title: "Modules")
    @modules = Array.wrap(modules).sort_by(&:name)
    @gem = gem
    @title = title
  end
end
