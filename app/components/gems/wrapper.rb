# frozen_string_literal: true

class Gems::Wrapper < ViewComponent::Base
  renders_one :sidebar

  def initialize(gem:, modules:, classes:, class_methods:, instance_methods:)
    @gem = gem
    @modules = modules
    @classes = classes
    @class_methods = class_methods
    @instance_methods = instance_methods
  end

  def overview_tabs
    [
      ["Home", gem_version_gem_path(@gem.name, @gem.version)],
      (["Guides", gem_version_guides_path(@gem.name, @gem.version)] if @gem.guide_files.any?),
      ["Reference", reference_gem_version_gem_path(@gem.name, @gem.version)],
      ["Types", gem_version_types_path(@gem.name, @gem.version)],
      ["Changelogs", changelogs_gem_version_gem_path(@gem.name, @gem.version)],
    ].compact
  end

  def tabs
    [
      ["Versions", gem_version_versions_path(@gem.name, @gem.version)],
      ["Source", gem_version_files_path(@gem.name, @gem.version)],
      ["Playground", playground_gem_version_gem_path(@gem.name, @gem.version)],
      ["Stats", stats_gem_version_gem_path(@gem.name, @gem.version)],
      ["Metadata", metadata_gem_version_gem_path(@gem.name, @gem.version)],
      ["Wiki", wiki_gem_version_gem_path(@gem.name, @gem.version)],
      ["Announcements", announcements_gem_version_gem_path(@gem.name, @gem.version)],
    ]
  end

  def community_tabs
    [
      ["Articles", articles_gem_version_gem_path(@gem.name, @gem.version)],
      ["Tutorials", tutorials_gem_version_gem_path(@gem.name, @gem.version)],
      ["Videos", videos_gem_version_gem_path(@gem.name, @gem.version)],
      ["Community", community_gem_version_gem_path(@gem.name, @gem.version)],
    ]
  end

  def docs_tabs
    [
      ["README", readme_gem_version_gem_path(@gem.name, @gem.version)],
      *(@gem.documentation_files - [@gem.readme]).sort.map do |file|
        name = file.split("/").last.split(".").first.humanize

        [name, gem_version_doc_path(@gem.name, @gem.version, file)]
      end,

      # ["Getting Started", gem_version_guide_path(@gem.name, @gem.version, title)],
      # ["Installation", gem_version_guide_path(@gem.name, @gem.version, title)],
      # ["Upgrade Guide", gem_version_guide_path(@gem.name, @gem.version, title)],
    ]
  end
end
