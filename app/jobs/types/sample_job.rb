# frozen_string_literal: true

class Types::SampleJob < ApplicationJob
  queue_as :default

  def perform(sample, source_ip)
    Rails.logger.debug ::Types::Sample.create(**sample.merge(source_ip:)).inspect
  end
end
