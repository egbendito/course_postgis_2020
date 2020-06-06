SELECT
    a.id,
    date_part('year', a.acq_date::date) yr,
    a.instrument sens,
    a.geom
  FROM 4_fire_mod a
  JOIN 3a_good_municipios_gz b ON ST_Intersects(ST_Transform(a.geom,3035),b.geom)
  ORDER BY yr ASC;
  
