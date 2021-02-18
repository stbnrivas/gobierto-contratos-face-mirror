# Gobierto Contratos - FACE importer

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

- nivel1: https://face.gob.es/api/v2/administraciones?nivel=1&page=1
- nivel1: https://face.gob.es/api/v2/administraciones?nivel=2&page=1
- ...

(Ojo que en los niveles 1 y 2 hay muy pocos elementos, es normal.)

Cada una de esas llamadas implementa una paginación pero no sabemos el número máximo de páginas.

La API devuelve un JSON muy sencillo del que tenemos que guardar el nombre, el DIR3.

Para cada elemento devuelto por la API se debe realizar otra llamada para importar la jerarquía (las
entidades hijas). Por ejemplo para el DIR3 L01401945, sus entidades hijas son: https://face.gob.es/api/v2/administraciones/L01401945/relaciones?administracion=L01401945&page=1&limit=10

## Tarea

- Cargar los datos de `db/fiscales.csv` en la base de datos. Las columnas del CSV y de la tabla de la base de datos coinciden

- Implementar una tarea Rake que realice una importación de toda la base de datos. La tarea deberå de aceptar un parámetro con el nivel que se quiere importar, y si no se proporciona importa todos.

- Si se crean servicios auxiliares, utilizar la carpeta `app/services` para alojarlos

- Se tienen que tener en cuenta las entidades existententes en la base de datos, si ya existen no se quieren actualizar, excepto por la jerarquía.

- Al finalizar la tarea se debe mostrar al usuario un resumen con los ítems procesados, importados o ignorados porque ya existían.

- Implementar tests, ya sea de la tarea Rake o de la clase o servicio que utilice la tarea rake.  Utilizar VCR para mockear las respuestas de la API y minitest como framework de testing.

- Si la tarea es muy costosa en tiempo se pueden usar jobs de Sidekiq, en ese caso proponer una solución para el reporte

- Entregar la tarea en una o varias PR incrementales


## Dudas o comentarios

fernando@populate.tools
