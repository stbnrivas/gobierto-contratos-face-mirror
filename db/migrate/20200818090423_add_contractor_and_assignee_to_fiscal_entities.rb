class AddContractorAndAssigneeToFiscalEntities < ActiveRecord::Migration[6.0]
  def change
    add_column :fiscal_entities, :is_contractor, :boolean, default: false
    add_column :fiscal_entities, :is_assignee, :boolean, default: false
  end
end
