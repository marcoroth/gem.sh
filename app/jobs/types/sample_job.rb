# frozen_string_literal: true

class Types::SampleJob < ApplicationJob
  retry_on Exception, wait: :exponentially_longer, attempts: 50

  queue_as :default

  def perform(sample, source_ip)
    sample = ::Types::Sample.create(**sample.merge(source_ip:))

    Rails.logger.debug sample.inspect

    raise "Couldn't process sample" unless sample.persisted?
  end
end
