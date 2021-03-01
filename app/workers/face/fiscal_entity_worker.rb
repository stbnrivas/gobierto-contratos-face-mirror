require 'pry'
class Face::FiscalEntityWorker
  include Sidekiq::Worker

  def perform(*args)
    level = args.first['level']
    dir3_list = args.first['dir3_to_import']
    processed = 0
    imported = 0
    ignored = 0
    # binding.pry

    dir3_list.each do |dir3|
      entities = Face::Dir3Entities.entities(level,dir3)
      entities.each do |entity|
        processed += 1
        process_entity(entity,imported,ignored)
      end
    end

    puts "#{processed.to_s.rjust(7,' ')} processed"
    puts "#{imported.to_s.rjust(7,' ')} imported"
    puts "#{ignored.to_s.rjust(7,' ')} ignored"
  end

  private
  def process_entity(entity,imported,ignored)
    non_exist = FiscalEntity.find_by(name: entity[:name]).nil?
    if non_exist
      FiscalEntity.create!(
        id: entity[:id],
        name: entity[:name],
        administration_level: entity[:administration_level],
        dir3: entity[:dir3],
        nifs: entity[:nifs],
        country_name: entity[:country_name],
        country_code: entity[:country_code],
        import_pending: entity[:import_pending]
      )
      imported += 1
    else
      ignored += 1
    end
  end
end
