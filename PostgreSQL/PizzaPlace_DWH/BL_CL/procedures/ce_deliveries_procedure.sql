SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_deliveries_procedure(
    OUT username name,
    OUT table_name text,
    OUT procedure_name text,
    OUT rows_updated int,
    OUT rows_inserted int,
    OUT procedure_starttime TEXT,
    OUT status text
) AS $$
DECLARE 
    count_before INT;
    count_after INT;
    rows_aff INT;
BEGIN 

    username := current_user;
    table_name := 'bl_3nf.ce_deliveries';
    procedure_name := 'bl_cl.ce_deliveries_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_deliveries;

	WITH initial_table AS (
		SELECT DISTINCT
			COALESCE(upper(s.delivery_id), 'N.A.') AS delivery_src_id,
			'SA_ONLINE_SALES' AS source_system,
			'SRC_ONLINE_SALES' AS source_entity,
			COALESCE (upper(s.delivery_name), 'N.A.') AS delivery_name,
			COALESCE ((
				SELECT courier_id FROM bl_3nf.ce_couriers e 
				WHERE COALESCE(upper(s.courier_id), 'N.A.') = upper(e.courier_src_id) AND
					upper(e.source_system) = 'SA_ONLINE_SALES' AND 
					upper(e.source_entity) = 'SRC_ONLINE_SALES'
			), -1) AS courier_id,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_online_sales.src_online_sales s
		WHERE NOT EXISTS (
			SELECT 1 FROM bl_3nf.ce_deliveries t 
			LEFT JOIN bl_3nf.ce_couriers e ON t.courier_id = e.courier_id
			WHERE COALESCE(upper(s.delivery_id), 'N.A.') = upper(t.delivery_src_id) AND 
				upper(t.source_system) = 'SA_ONLINE_SALES' AND 
				upper(t.source_entity) = 'SRC_ONLINE_SALES' AND
				COALESCE(upper(s.delivery_name), 'N.A.') = upper(t.delivery_name) AND
				COALESCE(upper(s.courier_id), 'N.A.') = upper(e.courier_src_id)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
	INSERT INTO bl_3nf.ce_deliveries (
		delivery_id,
		delivery_src_id,
		source_system,
		source_entity,
		delivery_name,
		courier_id,
		insert_dt,
		update_dt
	)
	SELECT nextval('bl_3nf.ce_deliveries_id_seq'),
		delivery_src_id,
		source_system,
		source_entity,
		delivery_name,
		courier_id,
		insert_dt,
		update_dt
	FROM initial_table
	ON CONFLICT (delivery_src_id, courier_id) DO UPDATE
	SET 
	    delivery_name = EXCLUDED.delivery_name,
	    update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_deliveries;

    rows_inserted := count_after - count_before;
    rows_updated := rows_aff - rows_inserted;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;
    
--	COMMIT;
END;
$$ LANGUAGE plpgsql;
