# Gobierto Contratos - FACe importer

## Requisitos

- Ruby 2.7.1
- Postgres >= 12


## Setup

1. git clone git@github.com:PopulateTools/gobierto-contratos-face.git
2. cd gobierto-contratos-face
3. bundle install
4. bin/rails db:setup db:migrate

Para comprobar que todo ok:

1. bin/rails c
2. FiscalEntity.first

## Modelo de datos

Se ha entregado una aplicación Rails con un único modelo Entidad Fiscal. Las entidades fiscales son
organismos o empresas que participan en la contratación pública. En este caso vamos a trabajar solo
con organismos oficiales.

Se identifican por varios campos (ambos son únicos) :

- NIF
- DIR3, que es una clasificación oficial y que les proporciona un id único

Se proporciona un dump de la tabla fiscal_entities en `db/fiscal_entities.csv` con el campo Dir3
relleno.




## Objetivo

![image](open-licitaciones.png)



El objetivo del proyecto es ampliar el número de entidades (ahora hay aproximadamente 75k)
importándolas de una base de datos oficial llamada FACe: https://face.gob.es/es/directorio/administraciones

La web implementa una API no documentada, pero que vamos a utilizar para scrappear todo el contenido
y completar nuestra base de datos de entidades fiscales.

Hay entidades de 5 niveles, que se obtienen a través de estas llamadas:

- nivel1 `admon general del estado`: https://face.gob.es/api/v2/administraciones?nivel=1&provincia=&administracion=&page=1&limit=25
- nivel2 `comunidades autonomas`   : https://face.gob.es/api/v2/administraciones?nivel=2&provincia=&administracion=&page=1&limit=25
- nivel3 `entidades locales`       : https://face.gob.es/api/v2/administraciones?nivel=3&provincia=&administracion=&page=1&limit=25
- nivel4 `universidades`           : https://face.gob.es/api/v2/administraciones?nivel=4&provincia=&administracion=&page=1&limit=25
- nivel5 `otras instituciones`     : https://face.gob.es/api/v2/administraciones?nivel=5&provincia=&administracion=&page=1&limit=25


(Ojo que en los niveles 1 y 2 hay muy pocos elementos, es normal.)


Para saber el numero de paginas, debemos acceder primeramente a la paginacion asignando el parametro `page=0` por ejemplo:

https://face.gob.es/api/v2/administraciones?nivel=1&provincia&page=0


```json
{
  "pager": {
    "total":"44",
    "limit":25
    },
    "filter":{"fields":["administracion","provincia","nivel"]}
}
```

y a partir del numero de resultados calculamos el numero de paginas como:

```ruby
total = json[:pager][:total]
limit = json[:pager][:limit]
total_pages = (total / 25).ceil
```


Recorriendo todas las pagina obtenemos un listado de dir3 que son hijos de el nivel correspondiente

- pagina 1: https://face.gob.es/api/v2/administraciones?nivel=1&provincia=&administracion=&page=1&limit=25

```json
{
  "items": [
    {
      "codigo_dir": "E04585801",
      "nombre_admon": "Ministerio de Asuntos Exteriores y de Cooperaci\u00f3n"
    },
    {
      "codigo_dir": "E05024101",
      "nombre_admon": "Ministerio de Educaci\u00f3n y Formaci\u00f3n Profesional"
    },
    { "codigo_dir": "E00003601", "nombre_admon": "Ministerio de Fomento" },
    {
      "codigo_dir": "E04921401",
      "nombre_admon": "Ministerio de Educaci\u00f3n, Cultura y Deporte"
    },
    {
      "codigo_dir": "E04921301",
      "nombre_admon": "Ministerio de Hacienda y Administraciones Publicas"
    },
    {
      "codigo_dir": "E04921601",
      "nombre_admon": "Ministerio de Industria, Energia y Turismo"
    },
    {
      "codigo_dir": "E05024901",
      "nombre_admon": "Ministerio de Econom\u00eda y Empresa"
    },
    {
      "codigo_dir": "E05024401",
      "nombre_admon": "Ministerio de Agricultura, Pesca y Alimentaci\u00f3n"
    },
    {
      "codigo_dir": "E00004101",
      "nombre_admon": "Ministerio de la Presidencia"
    },
    {
      "codigo_dir": "E04921501",
      "nombre_admon": "Ministerio de Empleo y Seguridad Social"
    },
    {
      "codigo_dir": "E04990301",
      "nombre_admon": "Ministerio de Agricultura y Pesca, Alimentaci\u00f3n y Medio Ambiente"
    },
    { "codigo_dir": "E00003801", "nombre_admon": "Ministerio del Interior" },
    {
      "codigo_dir": "E04990401",
      "nombre_admon": "Ministerio de la Presidencia y para las Administraciones Territoriales"
    },
    { "codigo_dir": "E00003901", "nombre_admon": "Ministerio de Justicia" },
    {
      "codigo_dir": "E04921701",
      "nombre_admon": "Ministerio de Agricultura, Alimentacion y Medio Ambiente"
    },
    {
      "codigo_dir": "E04921901",
      "nombre_admon": "Ministerio de Sanidad, Servicios Sociales e Igualdad"
    },
    {
      "codigo_dir": "E04990101",
      "nombre_admon": "Ministerio de Hacienda y Funci\u00f3n P\u00fablica"
    },
    {
      "codigo_dir": "E04990201",
      "nombre_admon": "Ministerio de Energ\u00eda, Turismo y Agenda Digital"
    },
    {
      "codigo_dir": "E04990501",
      "nombre_admon": "Ministerio de Econom\u00eda, Industria y Competitividad"
    },
    { "codigo_dir": "EA0008567", "nombre_admon": "Presidencia del Gobierno" },
    {
      "codigo_dir": "E04921801",
      "nombre_admon": "Ministerio de Economia y Competitividad"
    },
    { "codigo_dir": "E00003301", "nombre_admon": "Ministerio de Defensa" },
    {
      "codigo_dir": "E05024801",
      "nombre_admon": "Ministerio de Cultura y Deporte"
    },
    {
      "codigo_dir": "E05025101",
      "nombre_admon": "Ministerio de Ciencia, Innovaci\u00f3n y Universidades"
    },
    {
      "codigo_dir": "E05023901",
      "nombre_admon": "Ministerio de Asuntos Exteriores, Uni\u00f3n Europea y Cooperaci\u00f3n"
    }
  ]
}

```

- pagina 2: https://face.gob.es/api/v2/administraciones?nivel=1&provincia=&administracion=&page=2&limit=25

```json
{
  "items": [
    {
      "codigo_dir": "E05024201",
      "nombre_admon": "Ministerio de Trabajo, Migraciones y Seguridad Social"
    },
    {
      "codigo_dir": "E05024701",
      "nombre_admon": "Ministerio para la Transici\u00f3n Ecol\u00f3gica"
    },
    {
      "codigo_dir": "E05065601",
      "nombre_admon": "Ministerio de Transportes, Movilidad y Agenda Urbana"
    },
    {
      "codigo_dir": "E05071301",
      "nombre_admon": "Ministerio de Ciencia e Innovaci\u00f3n"
    },
    { "codigo_dir": "E05071601", "nombre_admon": "Ministerio de Igualdad" },
    {
      "codigo_dir": "E05068001",
      "nombre_admon": "Ministerio para la Transici\u00f3n Ecol\u00f3gica y el Reto Demogr\u00e1fico"
    },
    {
      "codigo_dir": "E05024301",
      "nombre_admon": "Ministerio de Industria, Comercio y Turismo"
    },
    {
      "codigo_dir": "E05068901",
      "nombre_admon": "Ministerio de Asuntos Econ\u00f3micos y Transformaci\u00f3n Digital"
    },
    { "codigo_dir": "E05072201", "nombre_admon": "Ministerio de Consumo" },
    {
      "codigo_dir": "E05072501",
      "nombre_admon": "Ministerio de Inclusi\u00f3n, Seguridad Social y Migraciones"
    },
    {
      "codigo_dir": "E05067101",
      "nombre_admon": "Ministerio de la Presidencia, Relaciones Con las Cortes y Memoria Democr\u00e1tica"
    },
    {
      "codigo_dir": "E05024501",
      "nombre_admon": "Ministerio de la Presidencia, Relaciones Con las Cortes e Igualdad"
    },
    {
      "codigo_dir": "E05024601",
      "nombre_admon": "Ministerio de Pol\u00edtica Territorial y Funci\u00f3n P\u00fablica"
    },
    { "codigo_dir": "E05070101", "nombre_admon": "Ministerio de Sanidad" },
    {
      "codigo_dir": "E05066501",
      "nombre_admon": "Ministerio de Trabajo y Econom\u00eda Social"
    },
    { "codigo_dir": "E05024001", "nombre_admon": "Ministerio de Hacienda" },
    {
      "codigo_dir": "E05025001",
      "nombre_admon": "Ministerio de Sanidad, Consumo y Bienestar Social"
    },
    {
      "codigo_dir": "E05070401",
      "nombre_admon": "Ministerio de Derechos Sociales y Agenda 2030"
    },
    { "codigo_dir": "E05073401", "nombre_admon": "Ministerio de Universidades" }
  ]
}
```


tenemos por tanto el listado de dir3

```json
["E05024201", "E05024701", "E05065601"..."E05073401"]
```

por cada uno dir3 debemos preguntar ahora por sus entidades hijas:


- primero la paginacion  https://face.gob.es/api/v2/administraciones/E05024201/relaciones?administracion=E05024201&page=0&limit=25

```json
{
  "pager": {
    "total":"146",
    "limit":25
    },
    "filter":{"fields":["oc","og","ut"]
  }
}
```

- calculamos el numero de paginas 5


```ruby
total = json[:pager][:total]
limit = json[:pager][:limit]
total_pages = (total / 25).ceil
```

- pagina 1: https://face.gob.es/api/v2/administraciones/E05024201/relaciones?administracion=E05024201&page=1&limit=25

```json
{
  "items": [
    {
      "cifs": [],
      "administracion": {
        "nombre": "Ministerio de Trabajo, Migraciones y Seguridad Social",
        "codigo_dir": "E05024201",
        "cifs": []
      },
      "id": 61654,
      "og": {
        "codigo_dir": "EA0021624",
        "nombre": "Instituto Nacional de Seguridad y Salud en el Trabajo"
      },
      "ut": {
        "codigo_dir": "EA0021625",
        "nombre": "Centro Nacional de Verificacion de Maquinaria de Bizkaia (SEDE- BARACALDO)"
      },
      "oc": {
        "codigo_dir": "E00142903",
        "nombre": "Instituto Nacional de Seguridad e Higiene en el Trabajo"
      }
    },

    ...
  ]
}
```

- pagina 2: https://face.gob.es/api/v2/administraciones/E05024201/relaciones?administracion=E05024201&page=2&limit=25

- pagina 3: https://face.gob.es/api/v2/administraciones/E05024201/relaciones?administracion=E05024201&page=3&limit=25

- pagina 4: https://face.gob.es/api/v2/administraciones/E05024201/relaciones?administracion=E05024201&page=4&limit=25

- pagina 5: https://face.gob.es/api/v2/administraciones/E05024201/relaciones?administracion=E05024201&page=5&limit=25


en cada uno de los resultados de cada pagina deseamos guardar:
- el padre si no existia ya
- cada uno de los hijos si ya no existia ya

### NOTA

Qué es un DIR3

Los códigos DIR3 son tres códigos que se asignan respectivamente a: Órgano gestor, Unidad Tramitadora y Oficina contable de una entidad pública. Y son obligatorios para poder emitir una factura electrónica a la Administración Pública.

El código DIR3 está compuesto por una o dos letras iniciales, más siete u ocho números, por ejemplo: LA1111111.

> og - organo gestor
> ut - unidad tramitadora
> oc - oficina contable




de nuevo la paginacion funciona igual que en el anterior endpoint poniendo el parametro `page=0`

https://face.gob.es/api/v2/administraciones/L01401945/relaciones?administracion=L01401945&page=0&limit=10

```json
{"pager":{"total":"43","limit":25},"filter":{"fields":["oc","og","ut"]}}
```



## otros llamadas interesantes

1. https://face.gob.es/api/v2/administraciones/E04585801/relaciones?administracion=E04585801&page=0&limit=10

2. https://face.gob.es/api/v2/administraciones/E04585801/relaciones?administracion=&page=0&limit=10

> `1` tiene 45 entidades y `2` 41612 entidades
> ejemplos de DIR3 = [EA0018976 , L04090015, A11023675, I00000292, U02900001, LA0007558, A09006152, LO1150183]

```
TODO: buscar el significado de las una o dos letras con la que comienzan...
```

3. https://face.gob.es/api/v2/niveles-administracion

4. https://face.gob.es/api/v2/provincias

5. https://face.gob.es/api/v2/administraciones?nivel=5&provincia=&administracion=defensor+del+pueblo&page=0









## Tarea

- Cargar los datos de `db/fiscales.csv` en la base de datos. Las columnas del CSV y de la tabla de la base de datos coinciden

- Implementar una tarea Rake que realice una importación de toda la base de datos. La tarea deberå de aceptar un parámetro con el nivel que se quiere importar, y si no se proporciona importa todos.

- Si se crean servicios auxiliares, utilizar la carpeta `app/services` para alojarlos

- Se tienen que tener en cuenta las entidades existententes en la base de datos, si ya existen no se quieren actualizar, excepto por la jerarquía.

- Al finalizar la tarea se debe mostrar al usuario un resumen con los ítems procesados, importados o ignorados porque ya existían.

- Implementar tests, ya sea de la tarea Rake o de la clase o servicio que utilice la tarea rake.  Utilizar VCR para mockear las respuestas de la API y minitest como framework de testing.

- Si la tarea es muy costosa en tiempo se pueden usar jobs de Sidekiq, en ese caso proponer una solución para el reporte

- Entregar la tarea en una o varias PR incrementales

- Al final de la prueba, grabar un vídeo con [Loom](https://loom.com) (cuenta gratuita, son vídeos de måximo 5 minutos) explicando y razonando la solución, y mostrando las partes más relevantes, para mostrar tu trabajo. Nosotros usamos bastante vídeos cortos para mostrar y demostrar features, señalar bugs...




## Solucion:


```bash
cd gobierto-contratos-face-mirror

# set environment
cp .env.example .env

# run infra requirements
docker-compose up

# prepare db
bin/rails db:create
bin/rails db:migrate

bin/rails db:migrate RAILS_ENV=test

# run tests
bin/rails test

# import fiscal_entities.csv
bin/rails csv:load

# scrape face api for new entities passing level as params
bin/rails face:import_level[1]

# scrape face api for new entities for **ALL LEVELS**
bin/rails face:import_level
```


como parte del docker-compose tienes accesible la web de administracion sidekiq-ui en [localhost:9292](localhost:9292) para ver el estado de las tareas

```bash
# from now worker is off, to run
bundle exec sidekiq

# he preferido no poner un worker de sidekiq por ahora para tener control de si quiero ejecutar los procesos en background o empezar encolando niveles
```

## cosas a mejorar o tener en cuenta

- el modelo fiscal entities, quita las letras vocales con acentos para el campo slug

```
admininistración => admininistracin
seria mejor admininistracion
```
- la api tiene entidades repetidas en puedes verse en los vcr con las request
- la api en sus entidades tiene cifs no validos, que ahora mismo se desechan
- *creo* que seria mejor quitar el campo id del csv que se importa a veces las inserciones fallan por que el id ya está en uso.



## Dudas o comentarios

fernando@populate.tools
