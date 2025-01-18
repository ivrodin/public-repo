SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_pizzas_sizes_procedure(
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
    table_name := 'bl_3nf.ce_pizzas_sizes';
    procedure_name := 'bl_cl.ce_pizzas_sizes_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_pizzas_sizes;

	WITH initial_table AS (
		SELECT DISTINCT 
			COALESCE (s.pizza_size_id::varchar(255), 'N.A.') AS pizza_size_src_id,
			'BL_CL' AS source_system,
			'LKP_PIZZAS_SIZES' AS source_entity,
			COALESCE (upper(s.pizza_size_name), 'N.A.') AS pizza_size_name,
			current_timestamp AS insert_dt ,
			current_timestamp AS update_dt 
		FROM 
			bl_cl.lkp_pizzas_sizes  s
		WHERE 
			NOT EXISTS (
				SELECT 1 FROM bl_3nf.ce_pizzas_sizes t 
				WHERE upper(s.pizza_size_id::text) = upper(t.pizza_size_src_id) AND 
					upper(t.source_system) = 'BL_CL' AND 
					upper(t.source_entity) = 'LKP_PIZZAS_SIZES'
			) AND (s.update_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
	)
	INSERT INTO bl_3nf.ce_pizzas_sizes (
		pizza_size_id,
		pizza_size_src_id,
		source_system,
		source_entity,
		pizza_size_name,
		insert_dt,
		update_dt
	)
	SELECT nextval('bl_3nf.ce_pizzas_sizes_id_seq'),
		pizza_size_src_id,
		source_system,
		source_entity,
		pizza_size_name,
		insert_dt,
		update_dt
	FROM initial_table
	ON CONFLICT (pizza_size_src_id, source_system, source_entity) DO UPDATE
	SET 
	    pizza_size_name = EXCLUDED.pizza_size_name,
	    update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_pizzas_sizes;

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
