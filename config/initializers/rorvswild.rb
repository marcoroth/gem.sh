# frozen_string_literal: true

return unless Rails.env.production?

if (api_key = Rails.application.credentials.dig(:rorvswild, :api_key))
  RorVsWild.start(
    api_key: api_key,
    ignored_exceptions: [
      "ActionController::RoutingError",
      "ZeroDivisionError",
    ],
  )
end
