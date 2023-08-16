# frozen_string_literal: true

class AddReturnValueToTypesSamples < ActiveRecord::Migration[7.0]
  def change
    add_column :types_samples, :return_value, :string
  end
end
