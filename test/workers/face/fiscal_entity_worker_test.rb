require 'test_helper'
require "vcr"

class Face::FiscalEntityWorkerTest < Minitest::Test
  def test_process_entity_with_invalid_discard_nifs_and_import
    imported = 0
    ignored = 0
    FiscalEntity.find_by(name: "entity with one invalid nif")&.delete
    entity_from_api = {name: "entity with one invalid nif", administration_level: 1, parent_id: 1, dir3: "E04610101", nifs: ["Z8579791Z", "49020608H"], country_name: "España", country_code: "ES", import_pending: false}

    worker = Face::FiscalEntityWorker.new
    entity, result = worker.process_entity(entity_from_api)
    imported += 1 if result == :imported
    ignored  += 1 if result == :ignored

    assert_equal 1, imported
    assert_equal 0, ignored
  end

  def test_process_entity_with_nif_greater_than_one_with_invalid_nif_L01070012
    imported = 0
    ignored = 0
    FiscalEntity.find_by(name: "entity with two nifs")&.delete
    entity_from_api = {name: "entity with two nifs", administration_level: 1, parent_id: 1, dir3: "E04610101", nifs: ["L01070012", "P0700100A"], country_name: "España", country_code: "ES", import_pending: false}

    worker = Face::FiscalEntityWorker.new
    entity, result = worker.process_entity(entity_from_api)
    imported += 1 if result == :imported
    ignored  += 1 if result == :ignored

    assert_equal 1, imported
    assert_equal 0, ignored
  end

  def test_process_entity_when_entity_non_exist_will_be_imported
    imported = 0
    ignored = 0
    worker = Face::FiscalEntityWorker.new

    FiscalEntity.find_by(name: "No existing entity")&.delete
    entity_from_api = {name: "No existing entity", administration_level: 1, parent_id: 1, dir3: "E04610101", nifs: ["S2812001B"], country_name: "España", country_code: "ES", import_pending: false}
    entity, result = worker.process_entity(entity_from_api)
    imported += 1 if result == :imported
    ignored  += 1 if result == :ignored

    assert_equal 1, imported
    assert_equal 0, ignored
  end

  def test_process_entity_when_entity_already_exist_will_be_ignored
    imported = 0
    ignored = 0
    entity_from_db = FiscalEntity.create({id: 900000, name: "existing entity", administration_level: 1, parent_id: 1, dir3: "E04610101", nifs: ["S2812001B"], country_name: "España", country_code: "ES", import_pending: false})
    entity_from_api = {name: "existing entity", administration_level: 1, parent_id: 1, dir3: "E04610101", nifs: ["S2812001B"], country_name: "España", country_code: "ES", import_pending: false}

    worker = Face::FiscalEntityWorker.new
    entity, result = worker.process_entity(entity_from_api)
    imported += 1 if result == :imported
    ignored  += 1 if result == :ignored

    assert_equal 0, imported
    assert_equal 1, ignored
    entity_from_db.delete
  end

  def test_process_full_level_1_and_list_dir3
    worker = Face::FiscalEntityWorker.new
    counter = Face::FiscalEntityProcessingCounter.new
    level = 1
    dir3_list = ["E04585801","E05024101","E04921401","E00003601","E04921301","E04921601","E05024401","E05024901","E04921501","E00004101","E04990301","E00003801","E04990401","E04921701","E00003901","E04921901","E04990101","EA0008567","E04990501","E04990201","E00003301","E04921801","E05023901","E05025101","E05024801","E05024201","E05024701","E05065601","E05071301","E05071601","E05068001","E05024301","E05068901","E05072201","E05072501","E05067101","E05024501","E05024601","E05070101","E05066501","E05024001","E05025001","E05070401","E05073401"]
    dir3_list.each do |dir3|
      VCR.use_cassette("level_#{level}_dir3_#{dir3}") do
        worker.process_dir3(level,dir3,counter)
      end
    end
    processed, imported, ignored = counter.status

    assert_equal 6240, processed
  end

end
