if Rails.application.credentials.dig(:rorvswild, :api_key)
  RorVsWild::Client.new(
    api_key: Rails.application.credentials.dig(:rorvswild, :api_key),
    ignored_exceptions: [
      "ActionController::RoutingError",
      "ZeroDivisionError"
    ]
  )
end
