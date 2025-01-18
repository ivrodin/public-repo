SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_pizzas_procedure(
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
    table_name := 'bl_3nf.ce_pizzas';
    procedure_name := 'bl_cl.ce_pizzas_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_pizzas;

	WITH initial_table AS (
		SELECT DISTINCT 
			COALESCE (s.pizza_id::text, 'N.A.') AS pizza_src_id,
			'BL_CL' AS source_system,
			'LKP_PIZZAS' AS source_entity,
			COALESCE (upper(split_part(s.pizza_src_id, '_', 1)), 'N.A.') AS pizza_name,
			COALESCE((
                SELECT DISTINCT cpt.pizza_type_id 
                FROM bl_3nf.ce_pizzas_types cpt
                LEFT JOIN bl_cl.lkp_pizzas_types lpt ON cpt.pizza_type_src_id = lpt.pizza_type_id::text
                WHERE UPPER(lpt.pizza_type_src_id) = UPPER(split_part(s.pizza_src_id, '_', 2)) AND UPPER(cpt.pizza_type_name) = UPPER(split_part(s.pizza_src_id, '_', 2))
            ), -1) AS pizza_type_id,
            COALESCE((
                SELECT DISTINCT cps.pizza_size_id 
                FROM bl_3nf.ce_pizzas_sizes cps
                LEFT JOIN bl_cl.lkp_pizzas_sizes lps ON cps.pizza_size_src_id = lps.pizza_size_id::text
                WHERE UPPER(lps.pizza_size_src_id) = UPPER(split_part(s.pizza_src_id, '_', 3)) AND UPPER(cps.pizza_size_name) = UPPER(split_part(s.pizza_src_id, '_', 3))
            ), -1) AS pizza_size_id,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt 
		FROM 
			bl_cl.lkp_pizzas  s
		WHERE 
			NOT EXISTS (
				SELECT 1 FROM bl_3nf.ce_pizzas t 
				WHERE upper(s.pizza_id::text) = upper(t.pizza_src_id) AND 
					upper(t.source_system) = 'BL_CL' AND 
					upper(t.source_entity) = 'LKP_PIZZAS'
			) AND (s.update_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
	)
	INSERT INTO bl_3nf.ce_pizzas (
		pizza_id,
		pizza_src_id,
		source_system,
		source_entity,
		pizza_name,
		pizza_type_id,
		pizza_size_id,
		insert_dt,
		update_dt
	)
	SELECT nextval('bl_3nf.ce_pizzas_id_seq'),
		pizza_src_id,
		source_system,
		source_entity,
		pizza_name,
		pizza_type_id,
		pizza_size_id,
		insert_dt,
		update_dt
	FROM initial_table
	ON CONFLICT (pizza_src_id, source_system, source_entity) DO UPDATE
	SET 
	    update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_pizzas;

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
