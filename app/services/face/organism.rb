require 'faraday'
require 'json'

module Face
  class Organism
    PAGINATION_SIZE = 25.0

    def self.count(level)
      begin
        resp = JSON.parse(Faraday.get("https://face.gob.es/api/v2/administraciones?nivel=#{level}&page=0").body, symbolize_names: true)
        resp[:pager][:total].to_i
      rescue JSON::ParserError => pe
        puts "  FAIL while json parsing response"
        0
      end
    end

    def self.last_page(level)
      (count(level)  / PAGINATION_SIZE).ceil
    end

    def self.directory_organism_for(level,page)
      return [] if page == 0
      list_dir3 = []
      begin
        data = JSON.parse(Faraday.get("https://face.gob.es/api/v2/administraciones?nivel=#{level}&provincia=&page=#{page}&limit=#{PAGINATION_SIZE.to_i}").body, symbolize_names: true)
        data[:items].each do |item|
          list_dir3 << item[:codigo_dir]
        end
      rescue JSON::ParserError => pe
        puts "  FAIL while json parsing response"
      end
      list_dir3
    end

    def self.directory_organism(level)
      return [] unless (1..5).include? level
      list_dir3 = []
      1.upto(Face::Organism.last_page(level)) do |page|
        list_dir3 += Face::Organism.directory_organism_for(level,page)
      end
      list_dir3
    end
  end # end class
end # end module


