# frozen_string_literal: true

FactoryBot.define do
  factory :type_sample, class: Types::Sample do
    gem_name { "railties" }
    gem_version { "7.0.6" }
    receiver { "Rails" }
    method_name { "env" }
    parameters { [] }
    return_value { "String" }

    location { "/test/file.rb:123" }
    application_name { "gem.sh" }
    source_ip { "127.0.0.1" }
    type_fusion_version { TypeFusion::VERSION }
  end
end
