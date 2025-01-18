CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_deliveries_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_deliveries(
	delivery_id bigint PRIMARY KEY,
	delivery_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	delivery_name varchar(255) NOT NULL,
	courier_id int NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT delivery_courier_fk FOREIGN KEY (courier_id) REFERENCES bl_3nf.ce_couriers(courier_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT deliveries_unique UNIQUE (delivery_src_id, courier_id)
);
