class AddCustomPlaceIdColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :fiscal_entities, :custom_place_id, :integer
  end
end
