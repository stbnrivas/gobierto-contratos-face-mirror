require 'csv'

namespace :csv do

  desc "load csv by default `../fiscal_entities.csv`"
  task load: :environment do
    csv_payload = File.read(Rails.root.join('db', 'fiscal_entities.csv'))
    data = CSV.parse(csv_payload, :headers => true, :encoding => 'UTF-8')
    row_created = 0
    data.each do |row|
      refactor_row = row.to_hash
      refactor_row["id"] = refactor_row["id"].to_i
      refactor_row["external_id"] = refactor_row["external_id"].to_i
      refactor_row["external_id_type"] = refactor_row["external_id_type"].to_i
      refactor_row["entity_type"] = refactor_row["entity_tipe"].to_i
      refactor_row["entity_type"] = refactor_row["entity_tipe"].to_i
      refactor_row["place_id"] = refactor_row["place_id"].to_i
      refactor_row["province_id"] = refactor_row["province_id"].to_i
      refactor_row["autonomous_region_id"] = refactor_row["autonomous_region_id"].to_i
      refactor_row["ute_id"] = refactor_row["ute_id"].to_i
      refactor_row["custom_place_id"] = refactor_row["custom_place_id"].to_i
      refactor_row["is_contractor"] = refactor_row["is_contractor"]=='t' ? true : false
      refactor_row["is_assignee"] = refactor_row["is_assignee"]=='t' ? true : false
      refactor_row["postal_code"] = refactor_row["postal_code"].to_i
      refactor_row["import_pending"] = refactor_row["import_pending"]=='t' ? true : false
      FiscalEntity.create!(refactor_row)
      row_created += 1
    end
    puts "  OK #{row_created} rows created"
  end
end
