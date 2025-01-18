SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_orders_procedure(
    OUT username name,
    OUT table_name text,
    OUT procedure_name text,
    OUT rows_updated int,
    OUT rows_inserted int,
    OUT procedure_starttime TEXT,
    OUT status text
) AS $$
DECLARE 
	counts_before INT;
	counts_after INT;
    rows_aff INT;
BEGIN 

    username := current_user;
    table_name := 'bl_3nf.ce_orders';
    procedure_name := 'bl_cl.ce_orders_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

	SELECT count(*) INTO counts_before FROM bl_3nf.ce_orders;

	WITH online_orders AS (
		SELECT DISTINCT
			COALESCE (upper(s.order_id), 'N.A.') AS order_src_id,
			'SA_ONLINE_SALES' AS source_system,
			'SRC_ONLINE_SALES' AS source_entity,
			COALESCE (TO_TIMESTAMP(s."timestamp", 'DD-MM-YY HH24:MI')::TIMESTAMP WITHOUT TIME ZONE, '1900-01-01 00:00:00'::timestamp) AS order_timestamp,
			'ONLINE'::bl_3nf.type_order AS order_type,
			'N.A.'::bl_3nf.type_offline_order AS offline_order_type,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_online_sales.src_online_sales s
		WHERE NOT EXISTS (
			SELECT 1 FROM bl_3nf.ce_orders t
			WHERE upper(t.order_src_id) = COALESCE (upper(s.order_id), 'N.A.') AND 
				upper(t.source_system) = 'SA_ONLINE_SALES' AND 
				upper(t.source_entity) = 'SRC_ONLINE_SALES' AND 
				COALESCE (TO_TIMESTAMP(s."timestamp", 'DD-MM-YY HH24:MI')::TIMESTAMP WITHOUT TIME ZONE, '1900-01-01 00:00:00'::timestamp) = t.order_timestamp
		) AND (s.load_timestamp) > (SELECT max(last_src_dt) FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	),  restaurant_orders AS (
		SELECT DISTINCT
			COALESCE (upper(s.order_id), 'N.A.') AS order_src_id,
			'SA_RESTAURANT_SALES' AS source_system,
			'SRC_RESTAURANT_SALES' AS source_entity,
			COALESCE (TO_TIMESTAMP(s."timestamp", 'DD-MM-YY HH24:MI')::TIMESTAMP WITHOUT TIME ZONE, '1900-01-01 00:00:00'::timestamp) AS order_timestamp,
			'OFFLINE'::bl_3nf.type_order AS order_type,
			COALESCE (s.in_or_out::bl_3nf.type_offline_order, 'N.A.'::bl_3nf.type_offline_order) AS offline_order_type,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_restaurant_sales.src_restaurant_sales s
		WHERE NOT EXISTS (
			SELECT 1 FROM bl_3nf.ce_orders t
			WHERE upper(t.order_src_id) = COALESCE (upper(s.order_id), 'N.A.') AND 
				upper(t.source_system) = 'SA_RESTAURANT_SALES' AND 
				upper(t.source_entity) = 'SRC_RESTAURANT_SALES' AND 
				COALESCE (TO_TIMESTAMP(s."timestamp", 'DD-MM-YY HH24:MI')::TIMESTAMP WITHOUT TIME ZONE, '1900-01-01 00:00:00'::timestamp) = t.order_timestamp AND
				COALESCE (s.in_or_out::bl_3nf.type_offline_order, 'N.A.'::bl_3nf.type_offline_order) = t.offline_order_type
		) AND (s.load_timestamp) > (SELECT max(last_src_dt) FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
	)
	INSERT INTO bl_3nf.ce_orders (
		order_id,
		order_src_id,
		source_system,
		source_entity,
		order_timestamp,
		order_type,
		offline_order_type,
		insert_dt,
		update_dt 
	)
	SELECT 
		nextval('bl_3nf.ce_orders_id_seq'),
		order_src_id,
		source_system,
		source_entity,
		order_timestamp,
		order_type,
		offline_order_type,
		insert_dt,
		update_dt 
	FROM online_orders
	UNION ALL
	SELECT 
		nextval('bl_3nf.ce_orders_id_seq'),
		order_src_id,
		source_system,
		source_entity,
		order_timestamp,
		order_type,
		offline_order_type,
		insert_dt,
		update_dt 
	FROM restaurant_orders
	ON CONFLICT (order_src_id, source_system, source_entity) DO UPDATE
	SET 
	    update_dt = EXCLUDED.update_dt,
		order_timestamp = EXCLUDED.order_timestamp,
		order_type = EXCLUDED.order_type,
		offline_order_type = EXCLUDED.offline_order_type;

	GET DIAGNOSTICS rows_aff = ROW_COUNT;

	SELECT count(*) INTO counts_after FROM bl_3nf.ce_orders;


    rows_inserted := counts_after - counts_before;
    rows_updated := (rows_aff) - rows_inserted;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;
END;
$$ LANGUAGE plpgsql;
