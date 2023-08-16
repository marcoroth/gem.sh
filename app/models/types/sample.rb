# frozen_string_literal: true

class Types::Sample < ApplicationRecord
  validates :gem_name, :gem_version, :method_name, :location, :type_fusion_version, :application_name, :source_ip, :parameters, presence: true

  # validates :return_value, presence: true
end
