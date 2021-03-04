require 'faraday'
require 'json'

module Face
  class Dir3Entities
    PAGINATION_SIZE = 25.0

    def self.count(level,dir3)
      begin
        resp = JSON.parse(Faraday.get("https://face.gob.es/api/v2/administraciones/#{dir3}/relaciones?administracion=#{dir3}&page=0").body, symbolize_names: true)
        resp[:pager][:total].to_i
      rescue JSON::ParserError => pe
        puts "  FAIL while json parsing response"
        0
      end
    end

    def self.last_page(level,dir3)
      (count(level,dir3) / PAGINATION_SIZE).ceil
    end

    def self.parent_for_entities(level,dir3)
      begin
        resp = JSON.parse(Faraday.get("https://face.gob.es/api/v2/administraciones/#{dir3}/relaciones?administracion=#{dir3}&page=1&limit=#{PAGINATION_SIZE}").body, symbolize_names: true)
        parent(resp[:items].first,level)
      rescue JSON::ParserError => pe
        puts "  FAIL while json parsing response"
      end
    end

    def self.entities_for(level,dir3,parent_id,page)
      children = []
      begin
        resp = JSON.parse(Faraday.get("https://face.gob.es/api/v2/administraciones/#{dir3}/relaciones?administracion=#{dir3}&page=#{page}&limit=#{PAGINATION_SIZE}").body, symbolize_names: true)
        resp[:items].each do |entity|
          children << children(entity,level,parent_id)
        end
      rescue JSON::ParserError => pe
        puts "  FAIL while json parsing response"
      end
      return children
    end


    def self.entities(level,dir3,parent_id)
      children = []
      1.upto(Face::Dir3Entities.last_page(level,dir3)) do |page|
        children += entities_for(level,dir3,parent_id,page)
      end
      children
    end

    private

    def self.parent(entity,level)
      {
        name: entity[:administracion][:nombre],
        administration_level: level,
        dir3: entity[:administracion][:codigo_dir],
        nifs: entity[:administracion][:cifs].map{ |nif| nif[:nif] },
        country_name: 'España',
        country_code: 'ES',
        import_pending: false
      }
    end

    def self.children(entity,level,parent_id)
      {
        name: entity[:ut][:nombre],
        administration_level: level,
        dir3: entity[:ut][:codigo_dir],
        parent_id: parent_id,
        nifs: entity[:administracion][:cifs].map{ |nif| nif[:nif] },
        country_name: 'España',
        country_code: 'ES',
        import_pending: false
      }
    end
  end
end