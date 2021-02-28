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


https://face.gob.es/api/v2/administraciones?nivel=1&provincia=&administracion=&page=1&limit=25


La API devuelve un JSON muy sencillo del que tenemos que guardar el nombre, el DIR3.

```json
{
  "items": [
    {
      "codigo_dir": "E04585801",
      "nombre_admon": "Ministerio de Asuntos Exteriores y de Cooperación"
    },
    ...
  ]
}



Para saber el numero de paginas, debemos acceder primeramente a la paginacion asignando el parametro `page=0` por ejemplo:

https://face.gob.es/api/v2/administraciones?nivel=1&provincia&page=0


```json
{ "pager":
  {
    "total":"8254",
    "limit":25},
    "filter":
      {
        "fields":
          [
            "administracion",
            "provincia",
            "nivel"]
      }
}
```

y a partir del numero de resultados calculamos el numero de paginas como:

```ruby
total = json[:pager][:total]
limit = json[:pager][:limit]
total_pages = (total / 25).ceil
```


Para cada elemento devuelto por la API se debe realizar otra llamada para importar la jerarquía (las
entidades hijas). Por ejemplo para el DIR3 L01401945, sus entidades hijas son

https://face.gob.es/api/v2/administraciones/L01401945/relaciones?administracion=&page=1&limit=10


```json
{
  "items": [
    {
      "cifs": [{ "nif": "S2812001B" }],
      "administracion": {
        "nombre": "Ministerio de Asuntos Exteriores y de Cooperaci\u00f3n",
        "codigo_dir": "E04585801",
        "cifs": [{ "nif": "S2812001B" }]
      },
      "id": 58176,
      "og": {
        "codigo_dir": "E04585801",
        "nombre": "Ministerio de Asuntos Exteriores y de Cooperaci\u00f3n"
      },
      "ut": {
        "codigo_dir": "E04681701",
        "nombre": "S.G. de Administracion Financiera"
      },
      "oc": {
        "codigo_dir": "GE0014059",
        "nombre": "Oficina Contable. I.D. Ministerio de Asuntos Exteriores, Uni\u00f3n Europea y Coop."
      }
    },
    {
      "cifs": [
        { "nif": "S2812001B" },
        { "nif": "B2812001B" },
        { "nif": "S2821001B" },
        { "nif": "F2812001B" },
        { "nif": "S2811001B" },
        { "nif": "Q2812001B" }
      ],
      "administracion": {
        "nombre": "Ministerio de Asuntos Exteriores y de Cooperaci\u00f3n",
        "codigo_dir": "E04585801",
        "cifs": [{ "nif": "S2812001B" }]
      },
      "id": 58155,
      "og": {
        "codigo_dir": "E04588601",
        "nombre": "Subsecretaria de Asuntos Exteriores y de Cooperacion"
      },
      "ut": { "codigo_dir": "E04609201", "nombre": "Escuela Diplomatica" },
      "oc": {
        "codigo_dir": "GE0014059",
        "nombre": "Oficina Contable. I.D. Ministerio de Asuntos Exteriores, Uni\u00f3n Europea y Coop."
      }
    },

    ...

  ]
}
```

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


## Dudas o comentarios

fernando@populate.tools
