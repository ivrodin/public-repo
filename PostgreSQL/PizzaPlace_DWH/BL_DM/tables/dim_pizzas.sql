CREATE SCHEMA IF NOT EXISTS bl_dm;

CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_pizzas_surr_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_dm.dim_pizzas (
	pizza_surr_id bigint PRIMARY KEY,
	pizza_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	pizza_name varchar(255) NOT NULL,
	pizza_type_src_id int NOT NULL,
	pizza_type_name varchar(255) NOT NULL,
	pizza_size_src_id int NOT NULL,
	pizza_size_name varchar(255) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL
);
