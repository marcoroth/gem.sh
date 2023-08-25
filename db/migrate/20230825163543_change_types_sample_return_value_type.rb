# frozen_string_literal: true

class ChangeTypesSampleReturnValueType < ActiveRecord::Migration[7.0]
  def change
    reversible do |direction|
      direction.up do
        change_column :types_samples, :return_value, :jsonb, using: "to_json(return_value)"
      end

      direction.down do
        change_column :types_samples, :return_value, :string, using: %(to_jsonb(return_value)->>0)
      end
    end
  end
end
