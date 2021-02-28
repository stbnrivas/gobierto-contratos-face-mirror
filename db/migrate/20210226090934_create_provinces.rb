class CreateProvinces < ActiveRecord::Migration[6.1]
  def up
    create_table :provinces do |t|
      t.integer :external_id
      t.string :name

      t.timestamps
    end
    add_index :provinces, [:external_id], unique: true

    Province.create(external_id: 0 , name: "-Sin provincia asignada" )
    Province.create(external_id: 1 , name: "Araba/Álava"             )
    Province.create(external_id: 2 , name: "Albacete"                )
    Province.create(external_id: 3 , name: "Alicante/Alacant"        )
    Province.create(external_id: 4 , name: "Almería"                 )
    Province.create(external_id: 5 , name: "Ávila"                   )
    Province.create(external_id: 6 , name: "Badajoz"                 )
    Province.create(external_id: 7 , name: "Balears, Illes"          )
    Province.create(external_id: 8 , name: "Barcelona"               )
    Province.create(external_id: 9 , name: "Burgos"                  )
    Province.create(external_id: 10, name: "Cáceres"                 )
    Province.create(external_id: 11, name: "Cádiz"                   )
    Province.create(external_id: 12, name: "Castellón/Castelló"      )
    Province.create(external_id: 13, name: "Ciudad Real"             )
    Province.create(external_id: 14, name: "Córdoba"                 )
    Province.create(external_id: 15, name: "Coruña, A"               )
    Province.create(external_id: 16, name: "Cuenca"                  )
    Province.create(external_id: 17, name: "Girona"                  )
    Province.create(external_id: 18, name: "Granada"                 )
    Province.create(external_id: 19, name: "Guadalajara"             )
    Province.create(external_id: 20, name: "Gipuzkoa"                )
    Province.create(external_id: 21, name: "Huelva"                  )
    Province.create(external_id: 22, name: "Huesca"                  )
    Province.create(external_id: 23, name: "Jaén"                    )
    Province.create(external_id: 24, name: "León"                    )
    Province.create(external_id: 25, name: "Lleida"                  )
    Province.create(external_id: 26, name: "Rioja, La"               )
    Province.create(external_id: 27, name: "Lugo"                    )
    Province.create(external_id: 28, name: "Madrid"                  )
    Province.create(external_id: 29, name: "Málaga"                  )
    Province.create(external_id: 30, name: "Murcia"                  )
    Province.create(external_id: 31, name: "Navarra"                 )
    Province.create(external_id: 32, name: "Ourense"                 )
    Province.create(external_id: 33, name: "Asturias"                )
    Province.create(external_id: 34, name: "Palencia"                )
    Province.create(external_id: 35, name: "Palmas, Las"             )
    Province.create(external_id: 36, name: "Pontevedra"              )
    Province.create(external_id: 37, name: "Salamanca"               )
    Province.create(external_id: 38, name: "Santa Cruz de Tenerife"  )
    Province.create(external_id: 39, name: "Cantabria"               )
    Province.create(external_id: 40, name: "Segovia"                 )
    Province.create(external_id: 41, name: "Sevilla"                 )
    Province.create(external_id: 42, name: "Soria"                   )
    Province.create(external_id: 43, name: "Tarragona"               )
    Province.create(external_id: 44, name: "Teruel"                  )
    Province.create(external_id: 45, name: "Toledo"                  )
    Province.create(external_id: 46, name: "Valencia/València"       )
    Province.create(external_id: 47, name: "Valladolid"              )
    Province.create(external_id: 48, name: "Bizkaia"                 )
    Province.create(external_id: 49, name: "Zamora"                  )
    Province.create(external_id: 50, name: "Zaragoza"                )
    Province.create(external_id: 51, name: "Ceuta"                   )
    Province.create(external_id: 52, name: "Melilla"                 )
  end

  def down
    drop_table :provinces
    remove_index :provinces, [:external_id], unique: true
  end
end
