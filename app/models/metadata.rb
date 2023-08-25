# frozen_string_literal: true

Metadata = Data.define(:files, :dependencies, :authors, :error) do
  def initialize(files: [], dependencies: [], authors: [], error: nil)
    super
  end
end
