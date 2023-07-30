class GemInfo
  attr_accessor :analyzer

  def self.for(name)
    new(Gemspec.find(name))
  end

  def initialize(gemspec)
    @gemspec = gemspec
    @analyzer = Analyzer.new

    analyze
  end

  def files
    @gemspec.files
      .select { |file| file.ends_with?(".rb") }
      .select { |file| file.start_with?("lib/") || file.start_with?("app/") }
  end

  def markdown_files
    @gemspec.files.select { |x| x.end_with?(".md") }
  end

  def readme
    readme = markdown_files.find { |x| x.downcase.include?("readme") }

    readme = docs.first if readme.nil?

    readme
  end

  def classes
    @analyzer.classes
  end

  def analyze
    files.each do |file|
      path = "#{@gemspec.unpack_data_path}/#{file}"

      @analyzer.analyze(path)
    end
  end
end
