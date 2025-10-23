# frozen_string_literal: true

class UI::StatusBadge < ViewComponent::Base
  CLASSES = ClassVariants.build(
    base: "rounded-md bg-white px-2.5 py-1 text-xs font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 flex",
    variants: {},
    defaults: {},
  )

  def initialize(label:, status: :default, tooltip: nil)
    @status = status
    @tooltip = tooltip
    @label = label
  end

  def data
    if @tooltip
      { controller: "tippy", tippy_content: @tooltip }
    else
      {}
    end
  end

  def classes
    CLASSES.render
  end
end
