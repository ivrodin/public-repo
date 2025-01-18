CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_customers_scd_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_customers_scd(
	customer_id bigint,
	customer_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	customer_full_name varchar(255) NOT NULL,
	is_active varchar(1) NOT NULL,
	start_dt timestamp NOT NULL,
	end_dt timestamp NOT NULL,
	insert_dt timestamp NOT NULL,
	CONSTRAINT customers_scd_pk PRIMARY KEY (customer_id, start_dt)
);
