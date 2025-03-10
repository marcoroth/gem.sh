# frozen_string_literal: true

class UI::Badge < ViewComponent::Base
  CLASSES = ClassVariants.build(
    "rounded-md py-1 px-2 fs-step--2 monospace-font-family font-medium ring-1 ring-inset self-end",
    variants: {
      color: {
        gray: "bg-gray-50 text-gray-600 ring-gray-600/10",
        red: "bg-red-50 text-red-700 ring-red-600/10",
        yellow: "bg-yellow-50 text-yellow-800 ring-yellow-600/20",
        green: "bg-green-50 text-green-700 ring-green-600/20",
        blue: "bg-blue-50 text-blue-700 ring-blue-700/10",
        indigo: "bg-indigo-50 text-indigo-700 ring-indigo-700/10",
        purple: "bg-purple-50 text-purple-70 ring-purple-700/100",
        pink: "bg-pink-50 text-pink-700 ring-pink-700/10",
      },
    },
    defaults: {
      color: :gray,
    },
  )

  def initialize(label:, style: :gray)
    @label = label
    @style = style
  end

  def classes
    CLASSES.render(color: @style)
  end
end
