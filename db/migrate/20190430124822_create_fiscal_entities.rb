# frozen_string_literal: true

class CreateFiscalEntities < ActiveRecord::Migration[5.2]

  def change
    create_table :fiscal_entities do |t|
      t.string :name, null: false

      t.string :external_id, null: false
      t.integer :external_id_type, null: false

      t.integer :entity_type

      t.integer :place_id
      t.integer :province_id
      t.integer :autonomous_region_id
    end

    add_index :fiscal_entities, [:external_id, :external_id_type], unique: true
  end

end
