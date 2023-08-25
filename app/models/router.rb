# frozen_string_literal: true

module Router
  class << self
    include Rails.application.routes.url_helpers
  end
end
