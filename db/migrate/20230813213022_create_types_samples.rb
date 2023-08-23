# frozen_string_literal: true

class CreateTypesSamples < ActiveRecord::Migration[7.0]
  def change
    create_table :types_samples do |t|
      t.string :gem_name
      t.string :gem_version
      t.string :receiver
      t.string :method_name
      t.string :location
      t.string :type_fusion_version
      t.string :application_name
      t.string :source_ip
      t.jsonb :parameters

      t.timestamps
    end
  end
end
