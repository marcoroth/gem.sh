# frozen_string_literal: true

SourceFile = Data.define(:file, :gem) do
  def initialize(file:, gem: nil)
    super
  end

  def url(gem)
    Router.gem_file_path(gem.name, gem.version, file)
  end

  def source_path
    "#{gem.unpack_data_path}/#{file}"
  end

  def exist?
    file && gem.files.include?(file) && File.exist?(source_path)
  end

  def content
    exist? && File.read(source_path)
  end

  def title
    file
  end

  def to_s
    title
  end
end
