CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_orders_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type t
        JOIN pg_namespace n ON t.typnamespace = n.oid
        WHERE n.nspname = 'bl_3nf' AND
        	t.typname = 'type_order'
    ) THEN
        CREATE TYPE bl_3nf.type_order AS ENUM ('ONLINE', 'OFFLINE', 'N.A.');
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_type t
        JOIN pg_namespace n ON t.typnamespace = n.oid
        WHERE n.nspname = 'bl_3nf' AND
        	t.typname = 'type_offline_order'
    ) THEN
        CREATE TYPE bl_3nf.type_offline_order AS ENUM ('IN', 'OUT', 'N.A.');
    END IF;
END $$;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_orders(
	order_id bigint PRIMARY KEY,
	order_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	order_timestamp timestamp NOT NULL,
	order_type bl_3nf.type_order NOT NULL,
	offline_order_type bl_3nf.type_offline_order NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT order_unique UNIQUE (order_src_id, source_system, source_entity)
);
