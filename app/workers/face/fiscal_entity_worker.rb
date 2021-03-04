require 'pry'
require 'vcr'
require_relative 'fiscal_entity_processing_counter'

class Face::FiscalEntityWorker
  include Sidekiq::Worker

  def perform(*args)
    level = args.first['level']
    dir3_list = args.first['dir3_to_import']
    counter = FiscalEntityProcessingCounter.new

    dir3_list.each do |dir3|
      process_dir3(level,dir3,counter)
    end

    processed, imported, ignored = counter.status
    puts "#{processed.to_s.rjust(7,' ')} processed"
    puts "#{imported.to_s.rjust(7,' ')} imported"
    puts "#{ignored.to_s.rjust(7,' ')} ignored"
  end

  def process_dir3(level,dir3,counter)
    parent_from_api = Face::Dir3Entities.parent_for_entities(level,dir3)
    parent, result = process_entity(parent_from_api) # needs id for children's insertions
    counter.increment_imported if result == :imported
    counter.increment_ignored if result == :ignored
    counter.increment_processed

    entities = Face::Dir3Entities.entities(level,dir3,parent[:id])
    entities.each do |entity|
      entity, result = process_entity(entity)
      counter.increment_imported if result == :imported
      counter.increment_ignored if result == :ignored
      counter.increment_processed
    end
  end

  def process_entity(entity)
    entity_from_db = FiscalEntity.where(name: entity[:name]).limit(1).first
    if entity_from_db.nil?
      entity_from_db = FiscalEntity.new(entity)
      nifs_invalid = entity_from_db.remove_invalid_nifs!
      entity_from_db.save!
      [entity_from_db, :imported]
    else
      [entity_from_db, :ignored]
    end

  end
end
