class AddSlugToEntities < ActiveRecord::Migration[6.0]
  def change
    add_column :fiscal_entities, :slug, :string, unique: true, null: false, default: '', index: true
  end
end
