SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_districts_procedure(
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
    table_name := 'bl_3nf.ce_districts';
    procedure_name := 'bl_cl.ce_districts_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_districts;

	WITH initial_table AS (
		SELECT DISTINCT
			COALESCE (upper(s.district), 'N.A.') AS district_src_id,
			'SA_ONLINE_SALES' AS source_system,
			'SRC_ONLINE_SALES' AS source_entity,
			COALESCE (upper(s.district), 'N.A.') AS district_name ,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_online_sales.src_online_sales s
		WHERE NOT EXISTS (
			SELECT 1 FROM bl_3nf.ce_districts t 
			WHERE COALESCE (upper(s.district), 'N.A.') = upper(t.district_src_id) AND 
				upper(t.source_system) = 'SA_ONLINE_SALES' AND
				upper(t.source_entity) = 'SRC_ONLINE_SALES' AND
				COALESCE (upper(s.district), 'N.A.') = upper(t.district_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
	INSERT INTO bl_3nf.ce_districts (
		district_id,
		district_src_id,
		source_system,
		source_entity,
		district_name,
		insert_dt,
		update_dt
	)
	SELECT nextval('bl_3nf.ce_districts_id_seq'),
		district_src_id,
		source_system,
		source_entity,
		district_name,
		insert_dt,
		update_dt
	FROM initial_table
	ON CONFLICT (district_src_id, source_system, source_entity) DO UPDATE
	SET 
	    district_name = EXCLUDED.district_name,
	    update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_districts;

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
