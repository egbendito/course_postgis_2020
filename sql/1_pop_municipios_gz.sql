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
