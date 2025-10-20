# frozen_string_literal: true

class Gems::RBSController < Gems::BaseController
  def index
    require_samples = params[:require_samples].present?
    signature = @gem.rbs_signature(require_samples:)

    filename = "#{@gem.name}-#{@gem.version}-#{require_samples ? 'only-samples' : 'complete'}.rbs"

    if params[:download].present?
      send_data signature, type: "application/x-ruby", disposition: "attachment", filename: filename
    else
      render plain: signature
    end
  end
end
