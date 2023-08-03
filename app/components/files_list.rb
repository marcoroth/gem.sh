# frozen_string_literal: true

class FilesList < ViewComponent::Base
  def initialize(files:, gem:, title: "Files")
    @files = files.sort_by(&:path)
    @gem = gem
    @title = title
  end
end
