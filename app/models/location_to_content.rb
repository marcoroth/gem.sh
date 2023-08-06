class LocationToContent
  def initialize(path, location)
    @path = path.to_s
    @location = location
  end

  def location
    @location
  end

  def code
    (File.exist?(@path) ? File.readlines(@path) : []).map { |line| line[location.start_column..] }
  end

  def location_content
    code[location.start_line-1..location.end_line-1].join
  end

  def signature
    code[location.start_line-1..location.start_line-1].join
  end

  def content
    code.join
  end
end
