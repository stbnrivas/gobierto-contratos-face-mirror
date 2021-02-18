# frozen_string_literal: true

class AddAddressFieldsToFiscalEntities < ActiveRecord::Migration[6.0]
  def change
    add_column :fiscal_entities, :address, :string
    add_column :fiscal_entities, :postal_code, :string
    add_column :fiscal_entities, :country_name, :string
    add_column :fiscal_entities, :country_code, :string
    add_column :fiscal_entities, :place_name, :string
  end
end
