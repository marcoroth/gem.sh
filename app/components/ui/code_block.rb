# frozen_string_literal: true

class UI::CodeBlock < ViewComponent::Base
  def initialize(language: "ruby")
    @language = language
  end

  def formatter
    @formatter ||= Rouge::Formatters::HTML.new
  end

  def lexer
    @lexer ||= Rouge::Lexers::Ruby.new
  end
end
