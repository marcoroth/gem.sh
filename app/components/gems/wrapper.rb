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
      ["Home", gem_version_path(@gem.name, @gem.version)],
      (["Guides", gem_guides_path(@gem.name, @gem.version)] if @gem.guide_files.any?),
      ["Reference", gem_reference_path(@gem.name, @gem.version)],
      ["Types", gem_types_path(@gem.name, @gem.version)],
      ["Changelogs", gem_changelogs_path(@gem.name, @gem.version)],
    ].compact
  end

  def tabs
    [
      ["Versions", gem_versions_path(@gem.name, @gem.version)],
      ["Source", gem_source_path(@gem.name, @gem.version)],
      ["Playground", gem_playground_path(@gem.name, @gem.version)],
      ["Stats", gem_stats_path(@gem.name, @gem.version)],
      ["Metadata", gem_metadata_path(@gem.name, @gem.version)],
      ["Wiki", gem_wiki_path(@gem.name, @gem.version)],
      ["Announcements", gem_announcements_path(@gem.name, @gem.version)],
    ]
  end

  def community_tabs
    [
      ["Articles", gem_articles_path(@gem.name, @gem.version)],
      ["Tutorials", gem_tutorials_path(@gem.name, @gem.version)],
      ["Videos", gem_videos_path(@gem.name, @gem.version)],
      ["Community", gem_community_path(@gem.name, @gem.version)],
    ]
  end

  def titles
    [
      ["README", gem_readme_path(@gem.name, @gem.version)],
      *(@gem.documentation_files - [@gem.readme]).sort.map do |file|
        name = file.split("/").last.split(".").first.humanize

        [name, gem_guide_path(@gem.name, @gem.version, file)]
      end,

      # ["Getting Started", gem_guide_path(@gem.name, @gem.version, title)],
      # ["Installation", gem_guide_path(@gem.name, @gem.version, title)],
      # ["Upgrade Guide", gem_guide_path(@gem.name, @gem.version, title)],
    ]
  end
end
