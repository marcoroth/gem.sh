# frozen_string_literal: true

class Types::Sample < ApplicationRecord
  validates :gem_name, :gem_version, :method_name, :location, :type_fusion_version, :application_name, :source_ip, presence: true

  # TODO: there are methods which don't have params.
  # Currently `[]` is considerd invalid since [].blank? returns true
  #
  # validates :parameters, presence: true

  # TODO: there are methods without return values
  #
  # validates :return_value, presence: true
end
