# frozen_string_literal: true

class NamespaceReopen < OpenStruct
  def initialize(path:, gem:, location: nil)
    super
  end

  def relative_path
    path.delete_prefix("#{gem.unpack_data_path}/")
  end

  def url(gem = nil)
    Router.gem_file_path(gem.name, gem.version, relative_path)
  end

  def title
    relative_path
  end
end
