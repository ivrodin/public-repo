SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.default_rows_procedure(
    OUT username name,
    OUT table_name text,
    OUT procedure_name text,
    OUT rows_updated int,
    OUT rows_inserted int,
    OUT procedure_starttime TEXT,
    OUT status text
)
AS $$
DECLARE
    rows_before INT;
    rows_after INT;
	rows_ins_total int := 0;
BEGIN 

    username := current_user;
    table_name := '3nf_and_dim_layers';
    procedure_name := 'bl_cl.default_rows_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';
	rows_updated := 0;

    SELECT count(*) INTO rows_before FROM bl_3nf.ce_couriers;

	INSERT INTO bl_3nf.ce_couriers (
		courier_id,
		courier_src_id,
		source_system,
		source_entity,
		courier_full_name,
		insert_dt,
		update_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', '1900-01-01'::timestamp , '1900-01-01'::timestamp
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_couriers WHERE courier_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_couriers;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after := 0;

--	COMMIT;

    SELECT count(*) INTO rows_before FROM bl_3nf.ce_deliveries;

	INSERT INTO bl_3nf.ce_deliveries (
		delivery_id,
		delivery_src_id,
		source_system,
		source_entity,
		delivery_name,
		courier_id,
		insert_dt,
		update_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', -1, '1900-01-01'::date , '1900-01-01'::date
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_deliveries WHERE delivery_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_deliveries;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

    SELECT count(*) INTO rows_before FROM bl_3nf.ce_customers_scd;

	INSERT INTO bl_3nf.ce_customers_scd (
		customer_id, 
		customer_src_id, 
		source_system, 
		source_entity, 
		customer_full_name, 
		is_active, 
		start_dt, 
		end_dt, 
		insert_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', 'Y', '1900-01-01'::timestamp , '1900-01-01'::timestamp, '1900-01-01'::timestamp
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_customers_scd WHERE customer_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_customers_scd;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

    SELECT count(*) INTO rows_before FROM bl_3nf.ce_districts;

	INSERT INTO bl_3nf.ce_districts (
		district_id,
		district_src_id,
		source_system,
		source_entity,
		district_name,
		insert_dt,
		update_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', '1900-01-01'::date , '1900-01-01'::date
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_districts WHERE district_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_districts;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_3nf.ce_addresses;

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
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', -1, '1900-01-01'::date , '1900-01-01'::date
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_addresses WHERE address_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_addresses;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_3nf.ce_employees;

	INSERT INTO bl_3nf.ce_employees (
		employee_id,
		employee_src_id,
		source_system,
		source_entity,
		employee_full_name,
		insert_dt,
		update_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', '1900-01-01'::date , '1900-01-01'::date
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_employees WHERE employee_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_employees;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_3nf.ce_pizzas_types;

	INSERT INTO bl_3nf.ce_pizzas_types (
		pizza_type_id,
		pizza_type_src_id,
		source_system,
		source_entity,
		pizza_type_name,
		insert_dt,
		update_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', '1900-01-01'::date , '1900-01-01'::date
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_pizzas_types WHERE pizza_type_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_pizzas_types;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_3nf.ce_pizzas_sizes;

	INSERT INTO bl_3nf.ce_pizzas_sizes (
		pizza_size_id,
		pizza_size_src_id,
		source_system,
		source_entity,
		pizza_size_name,
		insert_dt,
		update_dt
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', '1900-01-01'::date , '1900-01-01'::date
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_pizzas_sizes WHERE pizza_size_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_pizzas_sizes;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_3nf.ce_pizzas;

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
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', 'N.A.', -1, -1, '1900-01-01'::timestamp, '1900-01-01'::timestamp
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_pizzas WHERE pizza_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_pizzas;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_3nf.ce_orders;

	INSERT INTO bl_3nf.ce_orders (
		order_id,
		order_src_id,
		source_system,
		source_entity,
		order_timestamp,
		order_type,
		offline_order_type,
		insert_dt,
		update_dt 
	)
	SELECT -1, 'N.A.', 'MANUAL', 'MANUAL', '1900-01-01'::timestamp, 'N.A.'::bl_3nf.type_order, 'N.A.'::bl_3nf.type_offline_order, '1900-01-01'::timestamp, '1900-01-01'::timestamp
	WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_orders WHERE order_id = -1);

    SELECT count(*) INTO rows_after FROM bl_3nf.ce_orders;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_dm.dim_orders;

	INSERT INTO bl_dm.dim_orders (
		order_surr_id,
		order_src_id,
		source_system,
		source_entity,
		order_name,
		employee_src_id,
		employee_full_name,
		order_type,
		offline_order_type,
		delivery_src_id,
		delivery_name,
		courier_src_id,
		courier_full_name,
		insert_dt,
		update_dt	
	)
	SELECT 
		-1 AS order_surr_id, 
		'N.A.' AS order_src_id, 
		'MANUAL' AS source_system, 
		'MANUAL' AS source_entity, 
		'N.A.' AS order_name,
		'N.A.' AS employee_src_id, 
		'N.A.' AS employee_full_name, 
		'N.A.' AS order_type, 	
		'N.A.' AS offline_order_type, 
		'N.A.' AS delivery_src_id, 
		'N.A.' AS delivery_name,
		'N.A.' AS courier_src_id,
		'N.A.' AS courier_full_name,
		'1900-01-01'::timestamp AS insert_dt,
		'1900-01-01'::timestamp AS update_dt
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_orders 
		WHERE order_surr_id = -1 AND 
			upper(order_src_id) = 'N.A.' AND 
			upper(source_system) = 'MANUAL' AND 
			upper(source_entity) = 'MANUAL'
	);

    SELECT count(*) INTO rows_after FROM bl_dm.dim_orders ;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_dm.dim_addresses;

	INSERT INTO bl_dm.dim_addresses (
		address_surr_id,
		address_src_id,
		source_system,
		source_entity,
		address_name,
		district_src_id,
		district_name,
		insert_dt,
		update_dt	
	)
	SELECT 
		-1 AS address_surr_id, 
		'N.A.' AS address_src_id, 
		'MANUAL' AS source_system, 
		'MANUAL' AS source_entity, 
		'N.A.' AS address_name, 
		'N.A.' AS district_src_id, 
		'N.A.' AS district_name,
		'1900-01-01'::timestamp AS insert_dt,
		'1900-01-01'::timestamp AS update_dt
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_addresses 
		WHERE address_surr_id = -1 AND 
			upper(address_src_id) = 'N.A.' AND 
			upper(source_system) = 'MANUAL' AND 
			upper(source_entity) = 'MANUAL'
	);

    SELECT count(*) INTO rows_after FROM bl_dm.dim_addresses ;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_dm.dim_customers_scd;

	INSERT INTO bl_dm.dim_customers_scd (
		customer_surr_id,
		customer_src_id,
		source_system,
		source_entity,
		original_source,
		customer_full_name,
		is_active,
		start_dt,
		end_dt,
		insert_dt
	)
	SELECT 
		-1 AS customer_surr_id, 
		'N.A.' AS customer_src_id, 
		'MANUAL' AS source_system, 
		'MANUAL' AS source_entity, 
		'N.A.' AS original_source,
		'N.A.' AS customer_full_name,
		'Y' AS is_active,
		'1900-01-01'::timestamp AS start_dt,
		'1900-01-01'::timestamp AS end_dt,
		'1900-01-01'::timestamp AS insert_dt
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_customers_scd
		WHERE customer_surr_id = -1 AND 
			upper(customer_src_id) = 'N.A.' AND 
			upper(source_system) = 'MANUAL' AND 
			upper(source_entity) = 'MANUAL'
	);

    SELECT count(*) INTO rows_after FROM bl_dm.dim_customers_scd ;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_dm.dim_pizzas;

	INSERT INTO bl_dm.dim_pizzas (
		pizza_surr_id,
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
	)
	SELECT 
		-1 AS pizza_surr_id, 
		'N.A.' AS pizza_src_id, 
		'MANUAL' AS source_system, 
		'MANUAL' AS source_entity, 
		'N.A.' AS pizza_name,
		-1 AS pizza_type_src_id,
		'N.A.' AS pizza_type ,
		-1 AS pizza_size_src_id,
		'N.A.' AS pizza_size,
		'1900-01-01'::timestamp AS insert_dt,
		'1900-01-01'::timestamp AS update_dt
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_pizzas
		WHERE pizza_surr_id = -1 AND 
			upper(pizza_src_id) = 'N.A.' AND 
			upper(source_system) = 'MANUAL' AND 
			upper(source_entity) = 'MANUAL'
	);

    SELECT count(*) INTO rows_after FROM  bl_dm.dim_pizzas ;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_dm.dim_times;

	INSERT INTO bl_dm.dim_times (
		time_id,
		time_hourofday,
		time_quarterhour,
		time_minuteofday,
		time_daytimename,
		time_daynightname
	)
	SELECT 
		'N.A.' AS time_id, 
		-1 AS time_hourofday, 
		'N.A.' AS time_quarterhour, 
		-1 AS time_minuteofday, 
		'N.A.' AS time_daytimename,
		'N.A.' AS time_daynightname
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_times 
		WHERE upper(time_id) = 'N.A.' AND 
			time_hourofday = -1 AND 
			time_minuteofday = -1
	);

    SELECT count(*) INTO rows_after FROM  bl_dm.dim_times ;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_dm.dim_dates;

	INSERT INTO bl_dm.dim_dates (
		date_id,
		date_year,
		date_month,
		date_monthname,
		date_monthday,
		date_yearday,
		date_weekdayname,
		date_calendarweek,
		date_formatteddate,
		date_quarter,
		date_yearquarter,
		date_yearmonth,
		date_yearcalendarweek,
		date_weekend,
		date_georgianholiday,
		date_period,
		date_cwstart,
		date_cwend,
		date_monthstart,
		date_monthend
	)
	SELECT 
		'1900-01-01'::date AS date_id, 
		-1 AS date_year,
		-1 AS date_month,
		'N.A.' AS date_monthname,
		-1 AS date_monthday,
		-1 AS date_yearday,
		'N.A.' AS date_weekdayname,
		-1 AS date_calendarweek,
		'N.A.' AS date_formatteddate,
		'N.A.' AS date_quarter,
		'N.A.' AS date_yearquarter,
		'N.A.' AS date_yearmonth,
		'N.A.' AS date_yearcalendarweek,
		'N.A.' AS date_weekend,
		'N.A.' AS date_georgianholiday,
		'N.A.' AS date_period,
		'1900-01-01'::date AS date_cwstart,
		'1900-01-01'::date AS date_cwend,
		'1900-01-01'::date AS date_monthstart,
		'1900-01-01 00:00:00'::timestamp AS date_monthend
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_dates 
		WHERE date_id = '1900-01-01'::date AND 
			date_year = -1 AND 
			date_month = -1
	);

    SELECT count(*) INTO rows_after FROM  bl_dm.dim_dates  ;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

--	COMMIT;

   SELECT count(*) INTO rows_before FROM bl_cl.load_metadata;

	INSERT INTO bl_cl.load_metadata (load_id, src_tablename, last_src_dt, load_dt)
	SELECT -1, 'SRC_ONLINE_SALES','1900-01-01'::timestamp, '1900-01-01'::timestamp
	WHERE NOT EXISTS (SELECT 1 FROM bl_cl.load_metadata WHERE load_id = -1)
	UNION ALL
	SELECT -2, 'SRC_RESTAURANT_SALES','1900-01-01'::timestamp, '1900-01-01'::timestamp
	WHERE NOT EXISTS (SELECT 1 FROM bl_cl.load_metadata WHERE load_id = -2);

    SELECT count(*) INTO rows_after FROM  bl_cl.load_metadata;	

	rows_ins_total := rows_ins_total + (rows_after - rows_before);

	rows_before := 0;
	rows_after:= 0;

	rows_inserted := rows_ins_total;

--	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;

END;
$$ LANGUAGE plpgsql;
