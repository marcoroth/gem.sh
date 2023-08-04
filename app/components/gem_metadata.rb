# frozen_string_literal: true

class GemMetadata < ViewComponent::Base
  def initialize(gem:)
    @gem = gem
  end

  def types_status
    @gem.type_files.any? ? :green : :default
  end

  def types_tooltip
    types_status == :green ? "This gem ships type annotations" : "No type annotations detected"
  end

  def docs_status
    @gem.markdown_files.count > 3 ? :green : :default
  end

  def docs_tooltip
    docs_status == :green ? "This gem ships docs" : "No docs detected"
  end

  def guides_status
    :default
  end

  def guides_tooltip
    guides_status == :green ? "This gem ships guides" : "No guides detected"
  end

  def zeitwerk_status
    @gem.metadata.dependencies.map(&:name).include?("zeitwerk") ? :green : :default
  end

  def zeitwerk_tooltip
    zeitwerk_status == :green ? "This gem conform to the Zeitwerk conventions" : "This gem doesn't seem to conform to the Zeitwerk conventions"
  end

  def namespace_status
    :default
  end

  def namespace_tooltip
    namespace_status == :default ? "Does this gem follow the Rubygems namespace conventions?" : "TODO"
  end

  def optimized_status
    :default
  end

  def optimized_tooltip
    optimized_status == :green ? "TODO" : "Not optimized for gem.sh yet"
  end
end
