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

    def self.entities_for(level,dir3,page)
      entities = []
      begin
        resp = JSON.parse(Faraday.get("https://face.gob.es/api/v2/administraciones/#{dir3}/relaciones?administracion=#{dir3}&page=#{page}&limit=#{PAGINATION_SIZE}").body, symbolize_names: true)
        resp[:items].each do |entity|
          entities << entity_refactor(entity,level,dir3)
        end
      rescue JSON::ParserError => pe
        puts "  FAIL while json parsing response"
      end
      entities
    end


    def self.entities(level,dir3)
      entities = []
      1.upto(Face::Dir3Entities.last_page(level,dir3)) do |page|
        entities += entities_for(level,dir3,page)
      end
      entities
    end

    private

    def self.entity_refactor(entity,level,dir3)
      {
        id: entity[:id],
        name: entity[:administracion][:nombre],
        administration_level: level,
        dir3: dir3,
        nifs: entity[:administracion][:cifs].map{ |nif| nif[:nif] },
        country_name: 'España',
        country_code: 'ES',
        import_pending: true
      }
    end
  end
end