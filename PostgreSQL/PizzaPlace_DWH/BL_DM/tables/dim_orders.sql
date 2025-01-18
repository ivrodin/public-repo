CREATE SCHEMA IF NOT EXISTS bl_dm;

CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_orders_surr_id_seq
	START WITH 1
	INCREMENT BY 1
	CACHE 1;

CREATE TABLE IF NOT EXISTS bl_dm.dim_orders (
	order_surr_id bigint PRIMARY KEY,
	order_src_id varchar(255) NOT NULL,
	source_system varchar(255) NOT NULL,
	source_entity varchar(255) NOT NULL,
	order_name varchar(255) NOT NULL,
	employee_src_id varchar(255) NOT NULL,
	employee_full_name varchar(255) NOT NULL,
	order_type varchar(255) NOT NULL,
	offline_order_type varchar(255) NOT NULL,
	delivery_src_id varchar(255) NOT NULL,
	delivery_name varchar(255) NOT NULL,
	courier_src_id varchar(255) NOT NULL,
	courier_full_name varchar(255) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT dim_orders_unique UNIQUE (order_src_id, source_system, source_entity)
);

-- Creating index for fct_sales to use it
CREATE INDEX dim_orders_ind ON bl_dm.dim_orders (upper(order_src_id), upper(source_system), upper(source_entity));

-- Creating comosite type for cursor instead of RECORD
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
        WHERE t.typname = 'order_record_type'
        AND n.nspname = 'bl_dm'
    ) THEN
        CREATE TYPE bl_dm.order_record_type AS (
            order_src_id text,
            source_system text,
            source_entity text,
            order_name text,
            employee_src_id int,
            employee_full_name text,
            order_type text,
            offline_order_type text,
            delivery_src_id int,
            delivery_name text,
            courier_src_id int,
            courier_full_name text,
            insert_dt timestamp,
            update_dt timestamp
        );
    END IF;
END $$;
