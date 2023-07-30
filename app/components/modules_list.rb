# frozen_string_literal: true

class ModulesList < ViewComponent::Base
  def initialize(modules:, gem:)
    @modules = modules.sort_by(&:name)
    @gem = gem
  end
end
