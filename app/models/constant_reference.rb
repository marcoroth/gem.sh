# frozen_string_literal: true

ConstantReference = Data.define(:path, :location) do
  def initialize(path:, location: nil)
    super
  end
end
