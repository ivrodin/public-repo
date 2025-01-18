CREATE SCHEMA IF NOT EXISTS bl_dm;

CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_addresses_surr_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_dm.dim_addresses (
	address_surr_id bigint PRIMARY KEY,
	address_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	address_name varchar(255) NOT NULL,
	district_src_id varchar(255) NOT NULL,
	district_name varchar(255) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL
);
