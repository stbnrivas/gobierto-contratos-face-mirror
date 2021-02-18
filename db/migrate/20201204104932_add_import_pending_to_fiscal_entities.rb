class AddImportPendingToFiscalEntities < ActiveRecord::Migration[6.0]
  def change
    add_column :fiscal_entities, :import_pending, :boolean, default: false
  end
end
