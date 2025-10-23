# frozen_string_literal: true

class UI::Status < ViewComponent::Base
  CLASSES = ClassVariants.build(
    base: "flex-none rounded-full p-1 ",
    variants: {
      status: {
        default: "text-gray-500",
        orange: "text-orange-400",
        green: "text-green-400",
        red: "text-rose-400",
      },
    },
    defaults: {
      status: :default,
    },
  )

  def initialize(status:)
    @status = status
  end

  def classes
    CLASSES.render(status: @status)
  end
end
