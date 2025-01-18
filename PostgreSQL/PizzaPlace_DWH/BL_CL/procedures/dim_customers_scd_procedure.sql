SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.dim_customers_scd_procedure(
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
    table_name := 'bl_dm.dim_customers_scd';
    procedure_name := 'bl_cl.dim_customers_scd_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

	SELECT count(*) INTO counts_before FROM bl_dm.dim_customers_scd;

	WITH init_table AS (
		SELECT 
			customer_id::text AS customer_src_id ,
			'BL_3NF' AS source_system,
			'CE_CUSTOMERS_SCD' AS source_entity ,
			CASE 
				WHEN source_system = 'SA_ONLINE_SALES' THEN 'ONLINE'
				WHEN source_system = 'SA_RESTAURANT_SALES' THEN 'OFFLINE'
				ELSE 'MANUAL'
			END AS original_source,
			customer_full_name AS customer_full_name,
			is_active AS is_active,
			start_dt AS start_dt,
			end_dt AS end_dt,
			current_timestamp AS insert_dt
		FROM bl_3nf.ce_customers_scd s
		WHERE NOT EXISTS (            
		SELECT 1 FROM bl_dm.dim_customers_scd t 
            WHERE upper(s.customer_id::text) = upper(t.customer_src_id) AND 
				upper(t.original_source) = 'ONLINE' AND 
				upper(s.customer_full_name) = upper(t.customer_full_name) AND 
				upper(s.is_active) = upper(t.is_active) OR 
				upper(s.customer_id::text) = upper(t.customer_src_id) AND 
				upper(t.original_source) = 'OFFLINE' AND 
				upper(s.customer_full_name) = upper(t.customer_full_name) AND 
				upper(s.is_active) = upper(t.is_active)
		) AND customer_id::int > 0 AND (s.end_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
	)
	UPDATE bl_dm.dim_customers_scd t
	SET is_active = 'N',
		end_dt = current_timestamp
	WHERE EXISTS (
		SELECT 1 FROM init_table s
		WHERE t.customer_src_id::text = s.customer_src_id::TEXT AND 
			t.source_system = s.source_system AND 
			t.source_entity = s.source_entity AND
			t.original_source = s.original_source);

    GET DIAGNOSTICS rows_aff = ROW_COUNT;
	
	WITH init_table AS (
		SELECT 
			customer_id::text AS customer_src_id ,
			'BL_3NF' AS source_system,
			'CE_CUSTOMERS_SCD' AS source_entity ,
			CASE 
				WHEN source_system = 'SA_ONLINE_SALES' THEN 'ONLINE'
				WHEN source_system = 'SA_RESTAURANT_SALES' THEN 'OFFLINE'
				ELSE 'MANUAL'
			END AS original_source,
			customer_full_name AS customer_full_name,
			is_active AS is_active,
			start_dt AS start_dt,
			end_dt AS end_dt,
			current_timestamp AS insert_dt
		FROM bl_3nf.ce_customers_scd s
		WHERE NOT EXISTS (            
		SELECT 1 FROM bl_dm.dim_customers_scd t 
            WHERE upper(s.customer_id::text) = upper(t.customer_src_id) AND 
				upper(t.original_source) = 'ONLINE' AND 
				upper(s.customer_full_name) = upper(t.customer_full_name) OR 
				upper(s.customer_id::text) = upper(t.customer_src_id) AND 
				upper(t.original_source) = 'OFFLINE' AND 
				upper(s.customer_full_name) = upper(t.customer_full_name)
		) AND customer_id::int > 0 AND (s.end_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
	)
	INSERT INTO bl_dm.dim_customers_scd (customer_surr_id, customer_src_id, source_system, source_entity, original_source, customer_full_name, is_active, start_dt, end_dt, insert_dt)
	SELECT 
		nextval('bl_dm.dim_customers_scd_surr_id_seq'),
		customer_src_id, 
		source_system, 
		source_entity, 
		original_source, 
		customer_full_name, 
		is_active, 
		start_dt, 
		end_dt, 
		insert_dt
		FROM init_table;

	SELECT count(*) INTO counts_after FROM bl_dm.dim_customers_scd;


    rows_inserted := counts_after - counts_before;
    rows_updated := (rows_aff);

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;
END;
$$ LANGUAGE plpgsql;
