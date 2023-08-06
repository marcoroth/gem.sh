# frozen_string_literal: true

class LocationToContent
  attr_reader :path, :location

  def initialize(path, location)
    @path = path.to_s
    @location = location
  end

  def lines
    File.exist?(path) ? File.readlines(path) : []
  end

  def code
    lines.pluck(location.start_column..)
  end

  def location_content
    code[location.start_line - 1..location.end_line - 1].join
  end

  def signature
    code[location.start_line - 1..location.start_line - 1].join
  end

  def content
    code.join
  end
end
