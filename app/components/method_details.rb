# frozen_string_literal: true

class MethodDetails < ViewComponent::Base
  include YARDHelpers

  def initialize(object:, parent:, gem:)
    @object = object
    @parent = parent
    @gem = gem
  end

  def comments_content
    @object.comments.join("<br>").force_encoding("UTF-8")
  rescue StandardError
    ""
  end

  def yard
    YARD::Templates::Helpers::Markup::RDocMarkup.new(comments_content).to_html
  end

  def rdoc
    @rdoc ||= RDoc::Markup::ToHtml.new(RDoc::Options.new)
  end

  def rbs_signature?
    @object.try(:samples, @gem).present?
  end

  def samples
    @object.samples(@gem)
  end

  def rbs_signature
    @object.rbs_signature(@gem)
  end
end
