# frozen_string_literal: true

module ApplicationHelper
  def to_short_sentence(array, limit: 3)
    if array.length > limit
      remaining = array.length - limit

      "#{array.first(3).join(', ')} and #{remaining} more"
    else
      array.to_sentence
    end
  end
end
