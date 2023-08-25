# frozen_string_literal: true

module API
  module V1
    module Types
      class SamplesController < ApplicationController
        skip_before_action :verify_authenticity_token

        def create
          ::Types::SampleJob.perform_later(sample_params, request.remote_ip)

          head :ok
        end

        private

        def sample_params
          params.require(:sample).permit(:gem_name, :gem_version, :receiver, :method_name, :application_name, :type_fusion_version, :location, return_value: [], parameters: []).tap do |whitelisted|
            whitelisted[:parameters] = params.dig(:sample, :parameters)
            whitelisted[:return_value] = params.dig(:sample, :return_value)
          end
        end
      end
    end
  end
end
