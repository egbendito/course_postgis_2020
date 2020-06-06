SELECT
  a.codine,
  b.pobmun08,
  a.geom
FROM 1_comune_gz a
LEFT JOIN 2_pob_municipios_gz b ON a.codine=b.codine;
