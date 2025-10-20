# frozen_string_literal: true

class Gems::FilesController < Gems::BaseController
  before_action :set_file

  def index
  end

  def show
  end

  private

  def set_file
    @file = SourceFile.new(gem: @gem, file: params[:id]).existent
  end
end
