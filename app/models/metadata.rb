# frozen_string_literal: true

ConstantReference = Data.define(:files, :dependenices, :authors, :error) do
  def initialize(files: [], dependencies: [], authors: [], error: nil)
    super
  end
end
