SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.lkp_pizzas_sizes_procedure(
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
    rows_aff_online INT;
    rows_aff_offline INT;
BEGIN 

    username := current_user;
    table_name := 'bl_cl.lkp_pizzas_sizes';
    procedure_name := 'bl_cl.lkp_pizzas_sizes_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_cl.lkp_pizzas_sizes;

    WITH init_src AS (
            SELECT DISTINCT
                COALESCE(UPPER(s."size"), 'N.A.') AS pizza_size_src_id,
                'SA_ONLINE_SALES' AS source_system,
                'SRC_ONLINE_SALES' AS source_entity,
                COALESCE(UPPER(s."size"), 'N.A.') AS pizza_size_name,
                CURRENT_TIMESTAMP AS insert_dt,
                CURRENT_TIMESTAMP AS update_dt
            FROM 
                sa_online_sales.src_online_sales s
            WHERE NOT EXISTS (
                SELECT 1 
                FROM bl_cl.lkp_pizzas_sizes t
                WHERE COALESCE(UPPER(s."size"), 'N.A.') = UPPER(t.pizza_size_src_id)
                	AND UPPER(t.source_system) = 'SA_ONLINE_SALES'
                	AND UPPER(t.source_entity) = 'SRC_ONLINE_SALES'
					AND COALESCE(UPPER(s."size"), 'N.A.') = UPPER(t.pizza_size_name)
            ) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
	INSERT INTO bl_cl.lkp_pizzas_sizes (
        pizza_size_id,
        pizza_size_src_id,
        source_system,
        source_entity,
        pizza_size_name,
        insert_dt,
        update_dt
    )
    SELECT 
        COALESCE(
			(SELECT pizza_size_id FROM bl_cl.lkp_pizzas_sizes t WHERE upper(t.pizza_size_src_id) = upper(s.pizza_size_src_id)), 
			nextval('bl_cl.lkp_pizzas_sizes_id_seq')
		),
        pizza_size_src_id,
        source_system,
        source_entity,
        pizza_size_name,
        insert_dt,
        update_dt 
    FROM init_src s
    ON CONFLICT (pizza_size_src_id, source_system, source_entity) DO UPDATE
    SET 
        pizza_size_name = EXCLUDED.pizza_size_name,
        update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff_online = ROW_COUNT;

    WITH init_src AS (
            SELECT DISTINCT
                COALESCE(UPPER(s."size"), 'N.A.') AS pizza_size_src_id,
                'SA_RESTAURANT_SALES' AS source_system,
                'SRC_RESTAURANT_SALES' AS source_entity,
                COALESCE(UPPER(s."size"), 'N.A.') AS pizza_size_name,
                CURRENT_TIMESTAMP AS insert_dt,
                CURRENT_TIMESTAMP AS update_dt 
            FROM 
                sa_restaurant_sales.src_restaurant_sales s
            WHERE NOT EXISTS (
                SELECT 1 
                FROM bl_cl.lkp_pizzas_sizes t
                WHERE COALESCE(UPPER(s."size"), 'N.A.') = UPPER(t.pizza_size_src_id)
                	AND UPPER(t.source_system) = 'SA_RESTAURANT_SALES'
                	AND UPPER(t.source_entity) = 'SRC_RESTAURANT_SALES'
					AND COALESCE(UPPER(s."size"), 'N.A.') = UPPER(t.pizza_size_name)
            ) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
	) 
    INSERT INTO bl_cl.lkp_pizzas_sizes (
        pizza_size_id,
        pizza_size_src_id,
        source_system,
        source_entity,
        pizza_size_name,
        insert_dt,
        update_dt
    )
    SELECT 
        COALESCE(
			(SELECT pizza_size_id FROM bl_cl.lkp_pizzas_sizes t WHERE upper(t.pizza_size_src_id) = upper(s.pizza_size_src_id)), 
			nextval('bl_cl.lkp_pizzas_sizes_id_seq')
		),
        pizza_size_src_id,
        source_system,
        source_entity,
        pizza_size_name,
        insert_dt,
        update_dt 
    FROM init_src s
    ON CONFLICT (pizza_size_src_id, source_system, source_entity) DO UPDATE
    SET 
        pizza_size_name = EXCLUDED.pizza_size_name,
        update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff_offline = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_cl.lkp_pizzas_sizes;

    rows_inserted := count_after - count_before;
    rows_updated := (rows_aff_online + rows_aff_offline) - rows_inserted;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;
    
--	COMMIT;
END;
$$ LANGUAGE plpgsql;
