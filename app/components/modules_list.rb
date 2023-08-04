# frozen_string_literal: true

class ModulesList < ViewComponent::Base
  def initialize(modules:, gem:, title: "Modules")
    @modules = Array.wrap(modules).sort_by(&:qualified_name)
    @gem = gem
    @title = title
  end
end
