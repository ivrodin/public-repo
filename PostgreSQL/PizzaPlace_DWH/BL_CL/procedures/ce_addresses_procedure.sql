SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_addresses_procedure(
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
    table_name := 'bl_3nf.ce_addresses';
    procedure_name := 'bl_cl.ce_addresses_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_addresses;

	WITH initial_table AS (
		SELECT DISTINCT
			COALESCE (upper(s.address), 'N.A.') AS address_src_id,
			'SA_ONLINE_SALES' AS source_system,
			'SRC_ONLINE_SALES' AS source_entity,
			COALESCE (upper(s.address), 'N.A.') AS address_name,
			COALESCE ((
				SELECT district_id FROM bl_3nf.ce_districts e 
				WHERE COALESCE(upper(s.district), 'N.A.') = upper(e.district_src_id) AND
					upper(e.source_system) = 'SA_ONLINE_SALES' AND 
					upper(e.source_entity) = 'SRC_ONLINE_SALES'
			), -1) AS district_id,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_online_sales.src_online_sales s
		WHERE NOT EXISTS (
			SELECT 1 FROM bl_3nf.ce_addresses t 
			WHERE COALESCE(upper(s.address), 'N.A.') = upper(t.address_src_id) AND 
				upper(t.source_system) = 'SA_ONLINE_SALES' AND 
				upper(t.source_entity) = 'SRC_ONLINE_SALES' AND
				COALESCE(upper(s.address), 'N.A.') = upper(t.address_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
	INSERT INTO bl_3nf.ce_addresses (
		address_id,
		address_src_id,
		source_system,
		source_entity,
		address_name,
		district_id,
		insert_dt,
		update_dt
	)
	SELECT nextval('bl_3nf.ce_addresses_id_seq'),
		address_src_id,
		source_system,
		source_entity,
		address_name,
		district_id,
		insert_dt,
		update_dt
	FROM initial_table
	ON CONFLICT (address_src_id, district_id) DO UPDATE
	SET 
	    address_name = EXCLUDED.address_name,
	    update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_addresses;

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
