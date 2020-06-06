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
