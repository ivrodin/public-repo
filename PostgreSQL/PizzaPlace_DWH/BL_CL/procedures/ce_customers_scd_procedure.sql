SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_customers_scd_procedure(
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
    rows_aff_online INT;  
    rows_aff_offline INT;
BEGIN 

    username := current_user;
    table_name := 'bl_3nf.ce_customers_scd';
    procedure_name := 'bl_cl.ce_customers_scd_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

	SELECT count(*) INTO counts_before FROM bl_3nf.ce_customers_scd;

	WITH src_cte AS (
        SELECT DISTINCT 
            COALESCE (s.customer_id, 'N.A.') AS customer_src_id,
            'SA_ONLINE_SALES' AS source_system,
            'SRC_ONLINE_SALES' AS source_entity,
            COALESCE (upper(s.customer_full_name), 'N.A.') AS customer_full_name,
            'Y' AS is_active,
            current_timestamp AS start_dt,
            '9999-12-31'::timestamp AS end_dt,
            current_timestamp AS insert_dt
        FROM sa_online_sales.src_online_sales s
		WHERE NOT EXISTS (
            SELECT 1 FROM bl_3nf.ce_customers_scd t 
            WHERE  COALESCE (s.customer_id, 'N.A.') = upper(t.customer_src_id) AND 
                upper(t.source_system) = 'SA_ONLINE_SALES' AND 
                upper(t.source_entity) = 'SRC_ONLINE_SALES' AND
				COALESCE (upper(s.customer_full_name), 'N.A.') = upper(t.customer_full_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
	UPDATE bl_3nf.ce_customers_scd t
	SET is_active = 'N',
		end_dt = current_timestamp
	WHERE EXISTS (
		SELECT 1 FROM src_cte s 
			WHERE upper(t.customer_src_id) = upper(s.customer_src_id) AND
	            upper(t.source_system) = 'SA_ONLINE_SALES' AND 
	            upper(t.source_entity) = 'SRC_ONLINE_SALES'
		);

    GET DIAGNOSTICS rows_aff_online = ROW_COUNT;
	
	WITH src_cte AS (
        SELECT DISTINCT 
            COALESCE (s.customer_id, 'N.A.') AS customer_src_id,
            'SA_ONLINE_SALES' AS source_system,
            'SRC_ONLINE_SALES' AS source_entity,
            COALESCE (upper(s.customer_full_name), 'N.A.') AS customer_full_name,
            'Y' AS is_active,
            current_timestamp AS start_dt,
            '9999-12-31'::timestamp AS end_dt,
            current_timestamp AS insert_dt
        FROM sa_online_sales.src_online_sales s
		WHERE NOT EXISTS (
            SELECT 1 FROM bl_3nf.ce_customers_scd t 
            WHERE COALESCE (s.customer_id, 'N.A.') = upper(t.customer_src_id) AND 
                upper(t.source_system) = 'SA_ONLINE_SALES' AND 
                upper(t.source_entity) = 'SRC_ONLINE_SALES' AND 
				COALESCE (upper(s.customer_full_name), 'N.A.') = upper(t.customer_full_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	)
	INSERT INTO bl_3nf.ce_customers_scd (customer_id, customer_src_id, source_system, source_entity, customer_full_name, is_active, start_dt, end_dt, insert_dt)
    SELECT 
        COALESCE(
			(SELECT customer_id FROM bl_3nf.ce_customers_scd t
				WHERE t.customer_src_id = s.customer_src_id AND 
					t.source_system = s.source_system AND
					t.source_entity = s.source_entity),
			nextval('bl_3nf.ce_customers_scd_id_seq')
		),
		s.customer_src_id,
		s.source_system,
		s.source_entity,
		s.customer_full_name,
		s.is_active,
		s.start_dt,
		s.end_dt,
		s.insert_dt
	FROM src_cte s;

	WITH src_cte AS (
        SELECT DISTINCT 
            COALESCE (s.customer_id, 'N.A.') AS customer_src_id,
            'SA_RESTAURANT_SALES' AS source_system,
            'SRC_RESTAURANT_SALES' AS source_entity,
            COALESCE (upper(s.customer_full_name), 'N.A.') AS customer_full_name,
            'Y' AS is_active,
            current_timestamp AS start_dt,
            '9999-12-31'::timestamp AS end_dt,
            current_timestamp AS insert_dt
        FROM sa_restaurant_sales.src_restaurant_sales s
		WHERE NOT EXISTS (
            SELECT 1 FROM bl_3nf.ce_customers_scd t 
            WHERE COALESCE (s.customer_id, 'N.A.')  = upper(t.customer_src_id) AND 
                upper(t.source_system) = 'SA_RESTAURANT_SALES' AND 
                upper(t.source_entity) = 'SRC_RESTAURANT_SALES' AND
				COALESCE (upper(s.customer_full_name), 'N.A.') = upper(t.customer_full_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
	)
	UPDATE bl_3nf.ce_customers_scd t
	SET is_active = 'N',
		end_dt = current_timestamp
	WHERE EXISTS (
		SELECT 1 FROM src_cte s 
			WHERE upper(t.customer_src_id) = upper(s.customer_src_id) AND
				upper(t.source_system) = 'SA_RESTAURANT_SALES' AND 
                upper(t.source_entity) = 'SRC_RESTAURANT_SALES'
		);

    GET DIAGNOSTICS rows_aff_offline = ROW_COUNT;
	
	WITH src_cte AS (
        SELECT DISTINCT 
            COALESCE (s.customer_id, 'N.A.') AS customer_src_id,
            'SA_RESTAURANT_SALES' AS source_system,
            'SRC_RESTAURANT_SALES' AS source_entity,
            COALESCE (upper(s.customer_full_name), 'N.A.') AS customer_full_name,
            'Y' AS is_active,
            current_timestamp AS start_dt,
            '9999-12-31'::timestamp AS end_dt,
            current_timestamp AS insert_dt
        FROM sa_restaurant_sales.src_restaurant_sales s
		WHERE NOT EXISTS (
            SELECT 1 FROM bl_3nf.ce_customers_scd t 
            WHERE COALESCE (s.customer_id, 'N.A.') = upper(t.customer_src_id) AND 
                upper(t.source_system) = 'SA_RESTAURANT_SALES' AND 
                upper(t.source_entity) = 'SRC_RESTAURANT_SALES' AND
				COALESCE (upper(s.customer_full_name), 'N.A.') = upper(t.customer_full_name)
		) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
	)
	INSERT INTO bl_3nf.ce_customers_scd (customer_id, customer_src_id, source_system, source_entity, customer_full_name, is_active, start_dt, end_dt, insert_dt)
    SELECT 
        COALESCE(
			(SELECT customer_id FROM bl_3nf.ce_customers_scd t
				WHERE t.customer_src_id = s.customer_src_id AND 
					t.source_system = s.source_system AND
					t.source_entity = s.source_entity),
			nextval('bl_3nf.ce_customers_scd_id_seq')
		),
		s.customer_src_id,
		s.source_system,
		s.source_entity,
		s.customer_full_name,
		s.is_active,
		s.start_dt,
		s.end_dt,
		s.insert_dt
	FROM src_cte s;



	SELECT count(*) INTO counts_after FROM bl_3nf.ce_customers_scd;

    rows_inserted := counts_after - counts_before;
    rows_updated := (rows_aff_online + rows_aff_offline);

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;


--	COMMIT;
END;
$$ LANGUAGE plpgsql;
