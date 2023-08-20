# frozen_string_literal: true

class RBSSignature < ViewComponent::Base
  def initialize(rbs:, samples: [])
    @rbs = rbs
    @samples = samples
  end

  def sample_count
    @samples.to_a.length
  end

  def application_count
    @samples.pluck(:application_name).uniq.count
  end
end
