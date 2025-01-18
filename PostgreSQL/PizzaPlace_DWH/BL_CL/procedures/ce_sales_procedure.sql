SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_sales_procedure(
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
    table_name := 'bl_3nf.ce_sales';
    procedure_name := 'bl_cl.ce_sales_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

	SELECT count(*) INTO counts_before FROM bl_3nf.ce_sales;
	
	WITH online_sales AS (
		SELECT
			COALESCE (co.order_id, -1) AS order_id,
			-1 AS employee_id,
			COALESCE ((
				SELECT delivery_id FROM bl_3nf.ce_deliveries cd
				LEFT JOIN bl_3nf.ce_couriers cc ON cd.courier_id = cc.courier_id
				WHERE COALESCE(upper(s.delivery_id), 'N.A.') = cd.delivery_src_id AND
					COALESCE(upper(s.courier_id), 'N.A.') = cc.courier_src_id AND
					cd.source_system = 'SA_ONLINE_SALES' AND
					cd.source_entity = 'SRC_ONLINE_SALES'
			), -1) AS delivery_id,
			COALESCE ((
				SELECT customer_id FROM bl_3nf.ce_customers_scd ccs
				WHERE COALESCE(upper(s.customer_id), 'N.A.') = ccs.customer_src_id AND
					ccs.source_system = 'SA_ONLINE_SALES' AND
					ccs.source_entity = 'SRC_ONLINE_SALES' AND
					ccs.is_active = 'Y'
			), -1) AS customer_id,
			COALESCE ((
				SELECT address_id FROM bl_3nf.ce_addresses ca
				LEFT JOIN bl_3nf.ce_districts cd ON ca.district_id = cd.district_id 
				WHERE COALESCE(upper(s.district), 'N.A.') = cd.district_src_id AND
					COALESCE(upper(s.address), 'N.A.') = ca.address_src_id AND 
					ca.source_system = 'SA_ONLINE_SALES' AND
					ca.source_entity = 'SRC_ONLINE_SALES'
			), -1) AS address_id,
			COALESCE ((
				SELECT pizza_id FROM bl_3nf.ce_pizzas cp
				LEFT JOIN bl_3nf.ce_pizzas_types cpt ON cp.pizza_type_id = cpt.pizza_type_id
					AND cpt.source_system = 'BL_CL' AND cpt.source_entity = 'LKP_PIZZAS_TYPES'
				LEFT JOIN bl_3nf.ce_pizzas_sizes cps ON cp.pizza_size_id = cps.pizza_size_id
					AND cps.source_system = 'BL_CL' AND cps.source_entity = 'LKP_PIZZAS_SIZES'
				WHERE COALESCE(upper(s.pizza_name), 'N.A.') = cp.pizza_name AND
					COALESCE(upper(s.pizza_type), 'N.A.') = cpt.pizza_type_name AND
					COALESCE(upper(s."size"), 'N.A.') = cps.pizza_size_name
					AND cp.source_system = 'BL_CL' AND cp.source_entity = 'LKP_PIZZAS'
			), -1) AS pizza_id,
			COALESCE(s.quantity::int, 0) as quantity,
			COALESCE(s.price::decimal(6,2), 0) as price,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_online_sales.src_online_sales s
		LEFT JOIN bl_3nf.ce_orders co ON COALESCE(upper(s.order_id), 'N.A.') = co.order_src_id AND
			co.source_system = 'SA_ONLINE_SALES' AND
			co.source_entity = 'SRC_ONLINE_SALES'
		WHERE (s.load_timestamp) > (SELECT max(last_src_dt) FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_ONLINE_SALES')
	),  restaurant_sales AS (
		SELECT
			COALESCE (co.order_id, -1) AS order_id,
			COALESCE ((
				SELECT employee_id FROM bl_3nf.ce_employees ce
				WHERE COALESCE(upper(s.employee_id), 'N.A.') = ce.employee_src_id AND
					ce.source_system = 'SA_RESTAURANT_SALES' AND
					ce.source_entity = 'SRC_RESTAURANT_SALES'
			), -1) AS employee_id,
			-1 AS delivery_id,
			COALESCE ((
				SELECT customer_id FROM bl_3nf.ce_customers_scd ccs
				WHERE COALESCE(upper(s.customer_id), 'N.A.') = ccs.customer_src_id AND
					ccs.source_system = 'SA_RESTAURANT_SALES' AND
					ccs.source_entity = 'SRC_RESTAURANT_SALES' AND
					ccs.is_active = 'Y'
			), -1) AS customer_id,
			-1 AS address_id,
			COALESCE ((
				SELECT pizza_id FROM bl_3nf.ce_pizzas cp
				LEFT JOIN bl_3nf.ce_pizzas_types cpt ON cp.pizza_type_id = cpt.pizza_type_id
					AND cpt.source_system = 'BL_CL' AND cpt.source_entity = 'LKP_PIZZAS_TYPES'
				LEFT JOIN bl_3nf.ce_pizzas_sizes cps ON cp.pizza_size_id = cps.pizza_size_id
					AND cps.source_system = 'BL_CL' AND cps.source_entity = 'LKP_PIZZAS_SIZES'
				WHERE COALESCE(upper(s.pizza_name), 'N.A.') = cp.pizza_name AND
					COALESCE(upper(s.pizza_type), 'N.A.') = cpt.pizza_type_name AND
					COALESCE(upper(s."size"), 'N.A.') = cps.pizza_size_name
					AND cp.source_system = 'BL_CL' AND cp.source_entity = 'LKP_PIZZAS'
			), -1) AS pizza_id,
			COALESCE(s.quantity::int, 0) as quantity,
			COALESCE(s.price::decimal(6,2), 0) as price,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM 
			sa_restaurant_sales.src_restaurant_sales s
		LEFT JOIN bl_3nf.ce_orders co ON COALESCE(upper(s.order_id), 'N.A') = co.order_src_id AND
			co.source_system = 'SA_RESTAURANT_SALES' AND
			co.source_entity = 'SRC_RESTAURANT_SALES'
		WHERE (s.load_timestamp) > (SELECT max(last_src_dt) FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
	)
	INSERT INTO bl_3nf.ce_sales (
		order_id,
		employee_id,
		delivery_id,
		customer_id,
		address_id,
		pizza_id,
		quantity,
		price,
		insert_dt,
		update_dt 
	)
	SELECT 
		order_id,
		employee_id,
		delivery_id,
		customer_id,
		address_id,
		pizza_id,
		quantity,
		price,
		insert_dt,
		update_dt 
	FROM online_sales
	UNION ALL
	SELECT 
		order_id,
		employee_id,
		delivery_id,
		customer_id,
		address_id,
		pizza_id,
		quantity,
		price,
		insert_dt,
		update_dt 
	FROM restaurant_sales;

	GET DIAGNOSTICS rows_aff = ROW_COUNT;

	SELECT count(*) INTO counts_after FROM bl_3nf.ce_sales;


    rows_inserted := counts_after - counts_before;
    rows_updated := (rows_aff) - rows_inserted;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;
END;
$$ LANGUAGE plpgsql;
