# **Practical PostGIS Course**
## Master GIScience
#### Universitá di Padova Gennaio 2020

### **Part I. Installing PostgreSQL ![](https://github.com/egbendito/corso_PostGIS/blob/master/img/postgresql1.png)**
* #### Obtain the installers:
      sudo apt-get install postgresql-11 pgadmin4
* #### Enter PostgreSQL shell:
      sudo su postgres
      psql
* #### Create a new `USER`:
      CREATE USER my_user;
* #### Create a new `DATABASE` and open it (need to exit and login as the new `USER`):
      CREATE DATABASE my_db;
      \q
      psql -U my_user -d my_db

*If there's an* `ERROR` *we need to check and adjust Postgres configuration parameters:*

      sudo nano /etc/postgresql/11/main/pg_hba.conf

*and change:*

    local   all             postgres                       peer

*to*:

    local   all             postgres                       md5

### **Part II. PostGIS ![](https://github.com/egbendito/corso_PostGIS/blob/master/img/postgis1.png)**
* #### Install PostGIS:
      sudo apt-get install postgis
* #### In the new `DATABASE`:
      CREATE EXTENSION postgis;
      CREATE EXTENSION postgis_raster;
      CREATE EXTENSION postgis_topology;

### **Part III. Load some data:**
* #### Using GDAL & OGR functionalities:
      ogr2ogr -f "PostgreSQL" -s_srs EPSG:3035 -t_srs EPSG:3035 PG:"host=localhost user=my_user dbname=my_db" /input_data/1_comune_gz.geojson
* #### Using Postgres directly:
      DROP TABLE IF EXISTS 2_pop_municipios_gz;
      CREATE TABLE 2_pop_municipios_gz
      (
        id integer NOT NULL DEFAULT nextval('2_pop_municipios_gz_id_seq'::regclass),
        codine integer,
        provincia character varying COLLATE pg_catalog."default",
        municipio character varying COLLATE pg_catalog."default",
        pobmun02 integer,
        pobmun04 integer,
        pobmun06 integer,
        pobmun08 integer,
        pobmun10 integer,
        pobmun12 integer,
        pobmun14 integer,
        CONSTRAINT 2_pop_municipios_gz_pkey PRIMARY KEY (id)
      );
      COPY 2_pop_municipios_gz FROM '/input_data/2_pob_municipios.csv' DELIMITER '|' CSV HEADER;

### **Part IV. Some Exercises:**
* #### Normal Joins.
We want to know the population in each comune in Galizia using:
  * Attribute table of population (ID = codine); Galicia only.
  * Geometries of populated places (ID = codine); Galicia only.

        SELECT
          a.codine,
          b.pobmun08,
          a.geom
        FROM 1_comune_gz a
        LEFT JOIN 2_pob_municipios_gz b ON a.codine=b.codine;

* #### Spatial Joins.
We want to distribute the population along larger areas (to avoid empty spaces). We use:
  * Geometries of populated places (ID = codine); Galicia only.
  * Geometries of municipalities in Galicia (ID = NULL).

        SELECT DISTINCT
          a.codine,
          b.provincia,
          b.municipio,
          c.geom
        FROM 1_comune_gz a
        LEFT JOIN 2_pob_municipios b ON a.codine=b.codine
        LEFT JOIN 3_bad_municipios_gz c ON ST_Intersects(a.geom,c.geom);

  Filter the table `3_bad_municipios_gz` to only GZ and make a new table `3a_good_municipios_gz`:

      CREATE TABLE 3a_good_municipios_gz AS
      SELECT DISTINCT
        a.codine,
        b.provincia,
        b.municipio,
        c.geom
      FROM 1_comune_gz a
      LEFT JOIN 2_pob_municipios b ON a.codine=b.codine
      LEFT JOIN 3_bad_municipios_gz c ON ST_Intersects(a.geom,c.geom);

  Then, let’s see how many fires occur in GZ between 2001 and 2014 🤔:

      SELECT
        a.id,
        date_part('year', a.acq_date::date) yr,
        a.instrument sens,
        a.geom
      FROM 4_fire_mod a
      JOIN 3a_good_municipios_gz b ON ST_Intersects(ST_Transform(a.geom,3035),b.geom)
      ORDER BY yr ASC;

  And calculate number of fires per municipality:

      SELECT
        b.codine,
        b.provincia,
        b.municipio,
        COUNT(a.id) n_fire,
        b.geom
      FROM 4_fire_mod a
      JOIN 3a_good_municipios_gz b ON ST_Intersects(ST_Transform(a.geom,3035), b.geom)
      GROUP BY b.codine,b.provincia,b.municipio,b.geom
      ORDER BY n_fire DESC;

* #### PostGIS `RASTER`.
Load raster into `PostGIS`:

      raster2pgsql -I -C -e -Y -s 3035 -t 6901x6169 /input_data/5a_lc_2012_gz.tif | psql -U my_user -d my_db -h localhost

  Calculate number of fires per land cover type:

      WITH
      lc AS
      (
      SELECT
        a.codine,
        a.provincia,
        a.municipio,
        (ST_DumpAsPolygons(ST_Clip(b.rast, 1, a.geom, true))).val,
        (ST_DumpAsPolygons(ST_Clip(b.rast, 1, a.geom, true))).geom
      FROM 3a_good_municipios_gz a, 5a_lc_2012_gz b
      WHERE ST_Intersects(a.geom,b.rast) AND a.codine=15001
      )
      SELECT
        c.field_2 landcover_type,
        COUNT(a.id) n_fire,
        ST_Union(b.geom) geom
      FROM 4_fire_mod a
      JOIN lc b ON ST_Intersects(ST_Transform(a.geom,3035),b.geom)
      JOIN lc_key c ON b.val::integer=c.field_1::integer
      GROUP BY c.field_2
      ORDER BY n_fire DESC;
