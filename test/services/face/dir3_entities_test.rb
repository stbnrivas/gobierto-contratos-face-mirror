require "test_helper"
require "vcr"


class Face::Dir3EntitiesTest < ActiveSupport::TestCase
  test "default pagination size is 25" do
    assert_equal 25.0, Face::Dir3Entities::PAGINATION_SIZE # 25 is the default pagination for angular app to be unseen
  end

  test "count for level=1 and dir3=E04585801" do
    VCR.use_cassette("number of result for level=1, dir3=E04585801") do
      assert_equal 45, Face::Dir3Entities.count(1,"E04585801")
    end
  end

  test "number of pages for level=1 and dir3=E04585801" do
    VCR.use_cassette("number of pages for level=1, dir3=E04585801") do
      assert_equal 2, Face::Dir3Entities.last_page(1,"E04585801")
    end
  end

  test "get name organism level 1 dir3 E04585801 " do
    VCR.use_cassette("entity_name_level1_dir3_E04585801") do
      expected_parent = {:name=>"Ministerio de Asuntos Exteriores y de Cooperación", :administration_level=>1, :dir3=>"E04585801", :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false}
      assert_equal expected_parent, Face::Dir3Entities.parent_for_entities(1,"E04585801")
    end
  end

  test "process level=1, dir3=E04585801, page=1" do
    level = 1
    page = 1
    parent = VCR.use_cassette("entities for level 1 dir3 E04585801 page 1 parent") do
      parent_from_api = Face::Dir3Entities.parent_for_entities(level,"E04585801")
      parent = FiscalEntity.find_by(name: parent_from_api[:name])
      parent = FiscalEntity.create!(parent_from_api) if parent.nil?
      parent
    end
    expected_parent = {:id=>parent[:id], :name=>"Ministerio de Asuntos Exteriores y de Cooperación", :dir3=>"E04585801", :administration_level=>1, :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false}
    expected_children = [
      {:name=>"Unidad Tramitadora",                                                                            :administration_level=>1, :dir3=>"EA0008539", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Gerencia Casa Árabe",                                                                           :administration_level=>1, :dir3=>"EA0003347", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Obra Pia de los Santos Lugares de Jerusalen (EA0008373)",                                       :administration_level=>1, :dir3=>"EA0008373", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"EA0008154 Consorcio Casa Del Mediterráneo",                                                     :administration_level=>1, :dir3=>"EA0008154", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"GERENCIA",                                                                                      :administration_level=>1, :dir3=>"EA0008156", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Vicesecretaria General Tecnica",                                                                :administration_level=>1, :dir3=>"E04609301", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Personal",                                                                              :administration_level=>1, :dir3=>"E04610101", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Obras y Amueblamiento de Inmuebles en el Exterior",                                     :administration_level=>1, :dir3=>"E04853401", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Gabinete del Secretario de Estado de Cooperación Internacional, para Iberoamerica y el Caribe", :administration_level=>1, :dir3=>"EA0014486", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Escuela Diplomática Acf",                                                                       :administration_level=>1, :dir3=>"GE0003819", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Representación Permantente ante la Unión Europea en Bruselas (REPER)",                          :administration_level=>1, :dir3=>"GE0012470", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Gabinete del Secretario de Estado para la Unión Europea",                                       :administration_level=>1, :dir3=>"E04586701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Escuela Diplomatica",                                                                           :administration_level=>1, :dir3=>"E04609201", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Oficialia Mayor",                                                                               :administration_level=>1, :dir3=>"E04610001", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Personal",                                                                              :administration_level=>1, :dir3=>"E04610101", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Proteccion y Asistencia Consular",                                                      :administration_level=>1, :dir3=>"E04610504", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Obras y Amueblamiento de Inmuebles en el Exterior",                                     :administration_level=>1, :dir3=>"E04853401", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Oficialía Mayor Exterior",                                                                      :administration_level=>1, :dir3=>"GE0003419", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Vicesecretaria General Tecnica",                                                                :administration_level=>1, :dir3=>"E04609301", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"Oficialia Mayor",                                                                               :administration_level=>1, :dir3=>"E04610001", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
      {:name=>"S.G. de Obras y Amueblamiento de Inmuebles en el Exterior",                                     :administration_level=>1, :dir3=>"E04853401", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false}
    ]

    children = VCR.use_cassette("entities for level 1 dir3 E04585801 page 1") do
      Face::Dir3Entities.entities_for(level,"E04585801",parent[:id],page)
    end

    assert_equal expected_parent, parent.as_json.symbolize_keys.select { |k,v| [:id, :name, :administration_level, :dir3, :nifs, :country_name, :country_code, :import_pending].include? k }
    assert_equal expected_children, children
  end

  test "process full level=1, dir3=E04585801" do
    parent = VCR.use_cassette("entities level 1 dir3 E04585801 pages 1 2 parent") do
      parent_from_api = Face::Dir3Entities.parent_for_entities(1,"E04585801")
      parent = FiscalEntity.find_by(name: parent_from_api[:name])
      parent = FiscalEntity.create!(parent_from_api) if parent.nil?
      parent
    end

    VCR.use_cassette("entities level 1 dir3 E04585801 pages 1 2") do
      expected_parent = {:id=>parent[:id], :name=>"Ministerio de Asuntos Exteriores y de Cooperación", :dir3=>"E04585801", :administration_level=>1, :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false}

      expected_children = [
        {:name=>"Unidad Tramitadora",                                                                            :administration_level=>1, :dir3=>"EA0008539", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Gerencia Casa Árabe",                                                                           :administration_level=>1, :dir3=>"EA0003347", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Obra Pia de los Santos Lugares de Jerusalen (EA0008373)",                                       :administration_level=>1, :dir3=>"EA0008373", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"EA0008154 Consorcio Casa Del Mediterráneo",                                                     :administration_level=>1, :dir3=>"EA0008154", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"GERENCIA",                                                                                      :administration_level=>1, :dir3=>"EA0008156", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Vicesecretaria General Tecnica",                                                                :administration_level=>1, :dir3=>"E04609301", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Personal",                                                                              :administration_level=>1, :dir3=>"E04610101", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Obras y Amueblamiento de Inmuebles en el Exterior",                                     :administration_level=>1, :dir3=>"E04853401", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Gabinete del Secretario de Estado de Cooperación Internacional, para Iberoamerica y el Caribe", :administration_level=>1, :dir3=>"EA0014486", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Escuela Diplomática Acf",                                                                       :administration_level=>1, :dir3=>"GE0003819", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Representación Permantente ante la Unión Europea en Bruselas (REPER)",                          :administration_level=>1, :dir3=>"GE0012470", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Gabinete del Secretario de Estado para la Unión Europea",                                       :administration_level=>1, :dir3=>"E04586701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Escuela Diplomatica",                                                                           :administration_level=>1, :dir3=>"E04609201", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Oficialia Mayor",                                                                               :administration_level=>1, :dir3=>"E04610001", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Personal",                                                                              :administration_level=>1, :dir3=>"E04610101", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Proteccion y Asistencia Consular",                                                      :administration_level=>1, :dir3=>"E04610504", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Obras y Amueblamiento de Inmuebles en el Exterior",                                     :administration_level=>1, :dir3=>"E04853401", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Oficialía Mayor Exterior",                                                                      :administration_level=>1, :dir3=>"GE0003419", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Vicesecretaria General Tecnica",                                                                :administration_level=>1, :dir3=>"E04609301", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Oficialia Mayor",                                                                               :administration_level=>1, :dir3=>"E04610001", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Administracion Financiera",                                                             :administration_level=>1, :dir3=>"E04681701", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Obras y Amueblamiento de Inmuebles en el Exterior",                                     :administration_level=>1, :dir3=>"E04853401", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Informatica, Comunicaciones y Redes",                                                   :administration_level=>1, :dir3=>"E04853501", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Gabinete del Secretario de Estado de Asuntos Exteriores",                                       :administration_level=>1, :dir3=>"E04923702", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Dirección General de Políticas de Desarrollo Sostenible",                                       :administration_level=>1, :dir3=>"EA0011721", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Dirección General de Comunicación e Información Diplomática",                                   :administration_level=>1, :dir3=>"EA0011725", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Dirección General de Comunicación e Información Diplomática",                                   :administration_level=>1, :dir3=>"EA0011725", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Oficialía Mayor Caja Pagadora",                                                                 :administration_level=>1, :dir3=>"GE0003418", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Sugicyr-Cf",                                                                                    :administration_level=>1, :dir3=>"GE0003479", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Vicesecretaría General Técnica-Coordinación",                                                   :administration_level=>1, :dir3=>"GE0003806", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Oficina de Información Diplomática - Acf",                                                      :administration_level=>1, :dir3=>"GE0003823", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Vicesecretaria General Tecnica",                                                                :administration_level=>1, :dir3=>"E04609301", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Oficialia Mayor",                                                                               :administration_level=>1, :dir3=>"E04610001", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Proteccion y Asistencia Consular",                                                      :administration_level=>1, :dir3=>"E04610504", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"S.G. de Informatica, Comunicaciones y Redes",                                                   :administration_level=>1, :dir3=>"E04853501", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Gabinete del Secretario de Estado de Asuntos Exteriores",                                       :administration_level=>1, :dir3=>"E04923702", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Servicio de Obras",                                                                             :administration_level=>1, :dir3=>"GE0003563", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Subdirección General de Personal-Seguros",                                                      :administration_level=>1, :dir3=>"GE0003820", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Unidad de Caja Pagadora 1",                                                                     :administration_level=>1, :dir3=>"GE0005937", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Unidad de Apoyo de la Dirección General de Políticas de Desarrollo Sostenible",                 :administration_level=>1, :dir3=>"EA0019235", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Departamento de Recursos Humanos, Conciliacion y Servicios Generales",                          :administration_level=>1, :dir3=>"E04771201", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false},
        {:name=>"Unidad Tramitadora",                                                                            :administration_level=>1, :dir3=>"EA0008539", :parent_id=>parent[:id], :nifs=>["S2812001B"], :country_name=>"España", :country_code=>"ES", :import_pending=>false}
      ]

      children = Face::Dir3Entities.entities(1,"E04585801",parent[:id])
      assert_equal expected_parent, parent.as_json.symbolize_keys.select { |k,v| [:id, :name, :administration_level, :dir3, :nifs, :country_name, :country_code, :import_pending].include? k }
      assert_equal expected_children, children
    end
  end

end