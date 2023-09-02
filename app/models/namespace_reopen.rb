# frozen_string_literal: true

NamespaceReopen = Data.define(:path, :gem, :location) do
  def initialize(path:, gem:, location: nil)
    super
  end

  def relative_path
    path.delete_prefix("#{gem.unpack_data_path}/")
  end

  def url(gem = nil)
    Router.gem_version_file_path(gem.name, gem.version, relative_path)
  end

  def title
    relative_path
  end
end
