# frozen_string_literal: true

class RBSSignature < ViewComponent::Base
  def initialize(rbs:)
    @rbs = rbs
  end
end
