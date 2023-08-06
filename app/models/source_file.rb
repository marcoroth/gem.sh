# frozen_string_literal: true

class SourceFile < OpenStruct
  def initialize(file:, gem: nil)
    super
  end

  def url(gem)
    Router.gem_source_path(gem.name, gem.version, file)
  end

  def title
    file
  end

  def to_s
    title
  end
end
