namespace :face do

  desc 'import level face and update using background job'
  task :import_level, [:level] => :environment do |task, args|
    abort "\n  bad argument level between 1 and 5 included or nil for all levels \n  try `bin/rails face:import[1]`" if !args[:level].nil? && ![*1..5].include?(args[:level].first.to_i)
    levels = [args[:level].to_i]
    levels = [*1..5] if args[:level].nil?

    levels.each do |level|
      dir3_list = Face::Organism.directory_organism(level)
      Face::FiscalEntityWorker.perform_async({level: level, dir3_to_import: dir3_list})
    end
  end

end

