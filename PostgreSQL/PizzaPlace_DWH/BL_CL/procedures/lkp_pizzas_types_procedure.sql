SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.lkp_pizzas_types_procedure(
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
    table_name := 'bl_cl.lkp_pizzas_types';
    procedure_name := 'bl_cl.lkp_pizzas_types_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_cl.lkp_pizzas_types;

    WITH init_src AS (
            SELECT DISTINCT
                COALESCE(UPPER(s.pizza_type), 'N.A.') AS pizza_type_src_id,
                'SA_ONLINE_SALES' AS source_system,
                'SRC_ONLINE_SALES' AS source_entity,
                COALESCE(UPPER(s.pizza_type), 'N.A.') AS pizza_type_name,
                CURRENT_TIMESTAMP AS insert_dt,
                CURRENT_TIMESTAMP AS update_dt
            FROM 
                sa_online_sales.src_online_sales s
            WHERE NOT EXISTS (
                SELECT 1 
                FROM bl_cl.lkp_pizzas_types t
                WHERE COALESCE(UPPER(s.pizza_type), 'N.A.') = UPPER(t.pizza_type_src_id)
                	AND UPPER(t.source_system) = 'SA_ONLINE_SALES'
                	AND UPPER(t.source_entity) = 'SRC_ONLINE_SALES'
					AND COALESCE(UPPER(s.pizza_type), 'N.A.') = UPPER(t.pizza_type_name)
            ) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
    INSERT INTO bl_cl.lkp_pizzas_types (
        pizza_type_id,
        pizza_type_src_id,
        source_system,
        source_entity,
        pizza_type_name,
        insert_dt,
        update_dt
    )
    SELECT 
        COALESCE(
			(SELECT pizza_type_id FROM bl_cl.lkp_pizzas_types t WHERE upper(t.pizza_type_src_id) = upper(s.pizza_type_src_id)), 
			nextval('bl_cl.lkp_pizzas_types_id_seq')
		),
        pizza_type_src_id,
        source_system,
        source_entity,
        pizza_type_name,
        insert_dt,
        update_dt 
    FROM init_src s
    ON CONFLICT (pizza_type_src_id, source_system, source_entity) DO UPDATE
    SET 
        pizza_type_name = EXCLUDED.pizza_type_name,
        update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff_online = ROW_COUNT;

    WITH init_src AS (
            SELECT DISTINCT
                COALESCE(UPPER(s.pizza_type), 'N.A.') AS pizza_type_src_id,
                'SA_RESTAURANT_SALES' AS source_system,
                'SRC_RESTAURANT_SALES' AS source_entity,
                COALESCE(UPPER(s.pizza_type), 'N.A.') AS pizza_type_name,
                CURRENT_TIMESTAMP AS insert_dt,
                CURRENT_TIMESTAMP AS update_dt 
            FROM 
                sa_restaurant_sales.src_restaurant_sales s
            WHERE NOT EXISTS (
                SELECT 1 
                FROM bl_cl.lkp_pizzas_types t
                WHERE COALESCE(UPPER(s.pizza_type), 'N.A.') = UPPER(t.pizza_type_src_id)
                	AND UPPER(t.source_system) = 'SA_RESTAURANT_SALES'
                	AND UPPER(t.source_entity) = 'SRC_RESTAURANT_SALES'
					AND COALESCE(UPPER(s.pizza_type), 'N.A.') = UPPER(t.pizza_type_name)
            ) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
	)
    INSERT INTO bl_cl.lkp_pizzas_types (
        pizza_type_id,
        pizza_type_src_id,
        source_system,
        source_entity,
        pizza_type_name,
        insert_dt,
        update_dt
    )
    SELECT 
        COALESCE(
			(SELECT pizza_type_id FROM bl_cl.lkp_pizzas_types t WHERE upper(t.pizza_type_src_id) = upper(s.pizza_type_src_id)), 
			nextval('bl_cl.lkp_pizzas_types_id_seq')
		),
        pizza_type_src_id,
        source_system,
        source_entity,
        pizza_type_name,
        insert_dt,
        update_dt 
    FROM init_src s
    ON CONFLICT (pizza_type_src_id, source_system, source_entity) DO UPDATE
    SET 
        pizza_type_name = EXCLUDED.pizza_type_name,
        update_dt = EXCLUDED.update_dt;

    GET DIAGNOSTICS rows_aff_offline = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_cl.lkp_pizzas_types;

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
