# frozen_string_literal: true

class ModulesList < ViewComponent::Base
  def initialize(modules:, title:, gem:)
    @modules = modules.sort_by(&:name)
    @gem = gem
    @title = title
  end
end
