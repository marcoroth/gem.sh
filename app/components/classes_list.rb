# frozen_string_literal: true

class ClassesList < ViewComponent::Base
  def initialize(classes:, gem:, title: "Classes")
    @classes = classes.sort_by(&:qualified_name)
    @gem = gem
    @title = title
  end
end
