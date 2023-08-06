# frozen_string_literal: true

class GemInfo
  attr_accessor :analyzer

  def self.for(name)
    new(GemSpec.find(name))
  end

  def initialize(gemspec)
    @gemspec = gemspec
    @analyzer = Analyzer.new(gemspec)

    analyze
  end

  def classes
    @analyzer.classes
  end

  def analyze
    @gemspec.files.each do |file|
      path = "#{@gemspec.unpack_data_path}/#{file}"

      @analyzer.analyze(path)
    end
  end
end
