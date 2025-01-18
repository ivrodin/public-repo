SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.dim_pizzas_procedure(
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
    table_name := 'bl_dm.dim_pizzas';
    procedure_name := 'bl_cl.dim_pizzas_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_dm.dim_pizzas;

	WITH init_table AS (
		SELECT 
			upper(cp.pizza_id::TEXT) AS pizza_src_id,
			'BL_3NF' AS source_system,
			'CE_PIZZAS' AS source_entity ,
			cp.pizza_name AS pizza_name,
			cp.pizza_type_id AS pizza_type_src_id ,
			cpt.pizza_type_name AS pizza_type_name ,
			cp.pizza_size_id AS pizza_size_src_id ,
			cps.pizza_size_name AS pizza_size_name ,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM bl_3nf.ce_pizzas cp 
		LEFT JOIN bl_3nf.ce_pizzas_types cpt ON cp.pizza_type_id = cpt.pizza_type_id
		LEFT JOIN bl_3nf.ce_pizzas_sizes cps ON cp.pizza_size_id = cps.pizza_size_id
		WHERE cp.pizza_id > 0 AND (cp.update_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
	)
	INSERT INTO bl_dm.dim_pizzas (pizza_surr_id, pizza_src_id, source_system, source_entity, pizza_name, pizza_type_src_id, pizza_type_name, pizza_size_src_id, pizza_size_name, insert_dt, update_dt)
	SELECT 
		nextval('bl_dm.dim_pizzas_surr_id_seq'),
		pizza_src_id, 
		source_system, 
		source_entity, 
		pizza_name, 
		pizza_type_src_id, 
		pizza_type_name, 
		pizza_size_src_id,
		pizza_size_name, 
		insert_dt, 
		update_dt
	FROM init_table s
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_pizzas t 
		WHERE upper(t.pizza_src_id::TEXT) = upper(s.pizza_src_id::TEXT) AND 
			upper(t.pizza_type_src_id::TEXT) = upper(s.pizza_type_src_id::TEXT) AND 
			upper(t.pizza_size_src_id::TEXT) = upper(s.pizza_size_src_id::TEXT)
	);

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_dm.dim_pizzas;

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
