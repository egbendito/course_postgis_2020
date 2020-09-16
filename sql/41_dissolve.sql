-- Query only. This does not create any new table, it just returns a "dissolve" function (ST_Union)
SELECT
  ST_Union(geom) geom
FROM 3a_good_municipios_gz;
