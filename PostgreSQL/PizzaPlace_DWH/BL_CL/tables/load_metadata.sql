CREATE SCHEMA IF NOT EXISTS bl_cl;

CREATE SEQUENCE IF NOT EXISTS bl_cl.load_meadata_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_cl.load_metadata (
	load_id int PRIMARY KEY,
	src_tablename varchar (255) NOT NULL,
	last_src_dt timestamp NOT NULL,
	load_dt timestamp NOT NULL
);
