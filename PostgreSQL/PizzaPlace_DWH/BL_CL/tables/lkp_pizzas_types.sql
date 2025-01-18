CREATE SCHEMA IF NOT EXISTS bl_cl;

CREATE SEQUENCE IF NOT EXISTS bl_cl.lkp_pizzas_types_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_cl.lkp_pizzas_types(
	pizza_type_id bigint,
	pizza_type_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	pizza_type_name varchar(255) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT lkp_pizzas_types_unique UNIQUE (pizza_type_src_id, source_system, source_entity)
);
