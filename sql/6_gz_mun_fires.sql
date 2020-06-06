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
