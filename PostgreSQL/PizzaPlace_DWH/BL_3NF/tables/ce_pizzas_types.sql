CREATE SCHEMA IF NOT EXISTS bl_3nf;

REATE SEQUENCE IF NOT EXISTS bl_3nf.ce_pizzas_types_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_pizzas_types(
	pizza_type_id bigint PRIMARY KEY,
	pizza_type_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	pizza_type_name varchar(255) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT pizza_type_unique UNIQUE (pizza_type_src_id, source_system, source_entity)
);
