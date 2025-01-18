CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_pizzas_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_pizzas(
	pizza_id bigint PRIMARY KEY,
	pizza_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	pizza_name varchar(255) NOT NULL,
	pizza_type_id int NOT NULL,
	pizza_size_id int NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT pizza_unique UNIQUE (pizza_src_id, source_system, source_entity),
	CONSTRAINT pizza_pizza_type_fk FOREIGN KEY (pizza_type_id) REFERENCES bl_3nf.ce_pizzas_types(pizza_type_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT pizza_pizza_size_fk FOREIGN KEY (pizza_size_id) REFERENCES bl_3nf.ce_pizzas_sizes(pizza_size_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
