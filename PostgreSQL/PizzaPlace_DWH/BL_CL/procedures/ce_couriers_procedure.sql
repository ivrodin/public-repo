SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_couriers_procedure(
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
    table_name := 'bl_3nf.ce_couriers';
    procedure_name := 'bl_cl.ce_couriers_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_couriers;

    MERGE INTO bl_3nf.ce_couriers t
    USING (
        SELECT DISTINCT
            COALESCE(upper(courier_id), 'N.A.') AS courier_src_id,
            'SA_ONLINE_SALES' AS source_system,
            'SRC_ONLINE_SALES' AS source_entity,
            COALESCE(upper(courier_full_name), 'N.A.') AS courier_full_name,
            current_timestamp AS insert_dt,
            current_timestamp AS update_dt
        FROM 
            sa_online_sales.src_online_sales s
        WHERE NOT EXISTS (
			SELECT 1 FROM bl_3nf.ce_couriers t 
			WHERE COALESCE(upper(s.courier_id), 'N.A.') = upper(t.courier_src_id) AND 
				upper(t.source_system) = 'SA_ONLINE_SALES' AND 
				upper(t.source_entity) = 'SRC_ONLINE_SALES' AND 
				upper(s.courier_full_name) = upper(t.courier_full_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
    ) AS s
    ON t.courier_src_id = s.courier_src_id
        AND t.source_system = s.source_system
        AND t.source_entity = s.source_entity
    WHEN MATCHED THEN
        UPDATE SET 
            courier_full_name = s.courier_full_name,
            update_dt = s.update_dt
    WHEN NOT MATCHED THEN
        INSERT (
            courier_id,
            courier_src_id,
            source_system,
            source_entity,
            courier_full_name,
            insert_dt,
            update_dt
        )
        VALUES (
            nextval('bl_3nf.ce_couriers_id_seq'),
            s.courier_src_id,
            s.source_system,
            s.source_entity,
            s.courier_full_name,
            s.insert_dt,
            s.update_dt
        );

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_couriers;

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
