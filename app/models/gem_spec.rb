# frozen_string_literal: true

class GemSpec
  def self.latest_version_for(name)
    return nil if name.blank?

    Gem.latest_spec_for(name).try(:version)
  end

  def self.find(name, version = nil)
    return nil if name.nil?

    version ||= latest_version_for(name)

    return nil if version.nil?

    info = Gems::V2.info(name, version)

    return nil if info.nil?

    new(info)
  end

  def initialize(version_info)
    @version_info = version_info

    return if exists?

    download_gem
    unpack
  end

  def name
    @version_info["name"]
  end

  def version
    @version_info["version"]
  end

  def released_at
    Date.parse(@version_info["version_created_at"])
  end

  def downloads
    @version_info["downloads"]
  end

  def gem_uri
    @version_info["gem_uri"]
  end

  def versions
    Gems.versions(name).uniq { |version| version["number"] }
  end

  def grouped_versions
    versions.group_by { |version| version["number"].split(".")[0..1].join(".") }
  end

  def classes
    info.analyzer.classes.sort_by(&:qualified_name)
  end

  def modules
    info.analyzer.modules.sort_by(&:qualified_name)
  end

  def instance_methods
    info.analyzer.instance_methods.sort_by(&:name)
  end

  def class_methods
    info.analyzer.class_methods.sort_by(&:name)
  end

  def top_level_modules
    modules.select { |namespace| namespace.namespace.blank? }
  end

  def most_used_constant
    constant = (modules + classes).map { |const| const.qualified_name.split("::").first }.flatten.tally.max_by(&:last)

    constant ? constant.first : name.capitalize
  end

  def find_class(name)
    classes.find { |klass| klass.qualified_name == name }
  end

  def find_class!(name)
    find_class(name) || raise(GemConstantNotFoundError, "Couldn't find class '#{name}'")
  end

  def find_module(name)
    modules.find { |namespace| namespace.qualified_name == name }
  end

  def find_module!(name)
    find_module(name) || raise(GemConstantNotFoundError, "Couldn't find module '#{name}'")
  end

  def find_namespace(name)
    find_module(name) || find_class(name)
  end

  def find_namespace!(name)
    find_namespace(name) || raise(GemConstantNotFoundError, "Couldn't find namespace '#{name}'")
  end

  def rbs_signature(require_samples: false)
    rbs_file = rbs_file_path(require_samples)
    return File.read(rbs_file) if File.exist?(rbs_file)

    namespaces = modules + classes

    rbs_method_signatures = namespaces.map { |namespace| namespace.rbs_signature(self, require_samples:) }.compact

    rbs_method_signatures.join("\n\n").tap do |content|
      File.write(rbs_file, content)
    end
  end

  def files
    metadata
      .files
      .select { |file| file.ends_with?(".rb") }
      .select { |file| file.start_with?("lib/", "app/") }
  end

  def markdown_files
    metadata.files.select { |file| file.end_with?(".md") }
  end

  def type_files
    metadata.files.select { |file| file.end_with?(".rbs") }
  end

  def readme
    markdown_files.find { |file| file.downcase.include?("readme") } || markdown_files.first
  end

  def readme_content
    if readme
      Rails::HTML5::FullSanitizer.new.sanitize(File.read("#{unpack_data_path}/#{readme}"))
    else
      "No README"
    end
  end

  def download_path
    "tmp/gems/#{name}".tap do |path|
      FileUtils.mkdir_p(path)
    end
  end

  def unpack_path
    "tmp/gems/#{name}/#{version}".tap do |path|
      FileUtils.mkdir_p(path)
    end
  end

  def unpack_data_path
    "#{unpack_path}/data".tap do |path|
      FileUtils.mkdir_p(path)
    end
  end

  def unpack_data_archive
    "#{unpack_path}/data.tar.gz"
  end

  def unpack_metadata_archive
    "#{unpack_path}/metadata.gz"
  end

  def unpack_metadata_file
    "#{unpack_path}/metadata"
  end

  def rbs_file_path(require_samples)
    "#{unpack_path}/#{name}_#{require_samples}.rbs"
  end

  def metadata
    @metadata ||= YAML.load_file(
      unpack_metadata_file,
      aliases: true,
      permitted_classes: [
        Gem::Dependency,
        Gem::Requirement,
        Gem::Specification,
        Gem::Version,
        Gem::Version::Requirement, # TODO: not sure why Psych still complains about DisallowedClass for `Gem::Version::Requirement`
        Time,
        Symbol,
      ],
    )
  rescue Psych::DisallowedClass => e
    Rails.logger.debug e.inspect

    Metadata.new
  end

  def download_filename
    "#{download_path}/#{version}.gem"
  end

  def exists?
    File.exist?(download_filename)
  end

  def download_gem
    File.open(download_filename, "w") do |file|
      file.binmode

      HTTParty.get(gem_uri, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end
  end

  def unpack
    system("tar xvf #{download_filename} --directory #{unpack_path}")
    system("tar xvf #{unpack_data_archive} --directory #{unpack_data_path}")
    system("gunzip #{unpack_metadata_archive}")
  end

  def info
    @info ||= GemInfo.new(self)
  end
end
