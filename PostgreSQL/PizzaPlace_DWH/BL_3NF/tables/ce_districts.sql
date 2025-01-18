CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_districts_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_districts(
	district_id bigint PRIMARY KEY,
	district_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	district_name varchar(255) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT districts_unique UNIQUE (district_src_id, source_system, source_entity)
);
