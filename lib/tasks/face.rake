require 'pry'

namespace :face do

  desc 'level'
  task :level, [:level] => :environment do |task, args|

    levels = [args[:level].to_i]
    levels = [*1..5] if args[:level].nil?
    row_processed = 0
    row_imported = 0
    row_ignored = 0

    puts "levels #{levels}"
    levels.each do |level|
      puts "  processing level #{level}"
      dir3_list = Face::Organism.directory_organism(level)
      dir3_list.each do |dir3|
        puts "    processing dir3 #{dir3}"
        entities = Face::Dir3Entities.entities(level,dir3)

        entities.each do |entity|
          row_processed += 1
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
            row_imported += 1
            puts "      row imported - #{entity[:name]}"
          else
            row_ignored += 1
            puts "      row ignored  - #{entity[:name]}"
          end
        end
        puts "#{row_processed.to_s.rjust(6,' ')} processed"
        puts "#{row_imported.to_s.rjust(6,' ')} imported"
        puts "#{row_ignored.to_s.rjust(6,' ')} ignored"
      end
    end

  end
end

