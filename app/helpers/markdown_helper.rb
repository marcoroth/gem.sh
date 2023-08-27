# frozen_string_literal: true

module MarkdownHelper
  def render_markdown(content)
    MarkdownRenderer.new(sanitize(content)).render
  end
end
