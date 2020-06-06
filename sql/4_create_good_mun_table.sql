-- First, create a table with IDs (codine) and attributes
CREATE TABLE 3a_good_municipios_gz AS
SELECT DISTINCT
  a.codine,
  b.provincia,
  b.municipio
FROM 1_comune_gz a;
-- Then, JOIN the geometries using IDs (codine)
ALTER TABLE 3a_good_municipios_gz ADD COLUMN geom geometry(MultiPolygon, 3035);
UPDATE 3a_good_municipios_gz
  SET geom = a.geom
  FROM
  (SELECT
    a.codine codine,
    b.geom
  FROM 1_comune_gz a
  LEFT JOIN 3_bad_municipios_gz b ON ST_Intersects(a.geom,b.geom)
  ) a
WHERE 3a_good_municipios_gz.codine = a.codine;
