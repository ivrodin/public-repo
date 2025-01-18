CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_addresses_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_addresses(
	address_id bigint PRIMARY KEY,
	address_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	address_name varchar(255) NOT NULL,
	district_id int NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT address_district_fk FOREIGN KEY (district_id) REFERENCES bl_3nf.ce_districts(district_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT addresses_unique UNIQUE (address_src_id, district_id)
);
