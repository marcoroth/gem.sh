# frozen_string_literal: true

class Layout::Status < ViewComponent::Base
  CLASSES = ClassVariants.build(
    "flex-none rounded-full p-1 ",
    variants: {
      status: {
        default: "text-gray-500 bg-gray-100/10",
        green: "text-green-400 bg-green-400/10",
        red: "text-rose-400 bg-rose-400/10",
      }
    },
    defaults: {
      status: :default,
    }
  )

  def initialize(status:)
    @status = status
  end

  def classes
    CLASSES.render(status: @status)
  end
end
