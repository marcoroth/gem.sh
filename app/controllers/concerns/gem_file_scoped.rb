# frozen_string_literal: true

module GemFileScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_file
  end

  private

  def set_file
    SourceFile.new(file: params[:id], gem: @gem).tap do |file|
      @file = file if file.exist?
    end
  end
end
