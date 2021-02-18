# frozen_string_literal: true

class FixFiscalEntitiesModel < ActiveRecord::Migration[5.2]

  def change
    add_column :fiscal_entities, :dir3, :string
    add_column :fiscal_entities, :ute_id, :string
    add_column :fiscal_entities, :administration_level, :integer
    add_column :fiscal_entities, :parent_id, :integer
    add_column :fiscal_entities, :nifs, :string, array: true, default: []

    # Drop previous constraints
    change_column :fiscal_entities, :external_id, :string, null: true
    change_column :fiscal_entities, :external_id_type, :integer, null: true
    remove_index :fiscal_entities, column: [:external_id, :external_id_type]
  end

end
