SELECT DISTINCT
  a.codine,
  b.provincia,
  b.municipio,
  c.geom
FROM 1_comune_gz a
LEFT JOIN 2_pob_municipios b ON a.codine=b.codine
LEFT JOIN 3_bad_municipios_gz c ON ST_Intersects(a.geom,c.geom);
