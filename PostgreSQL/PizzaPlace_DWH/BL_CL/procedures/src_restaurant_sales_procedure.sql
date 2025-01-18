SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.src_restaurant_sales_procedure (
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
    table_name := 'sa_restaurant_sales.src_restaurant_sales';
    procedure_name := 'bl_cl.src_restaurant_sales_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';
	rows_updated := 0;

	SELECT count(*) INTO count_before FROM sa_restaurant_sales.src_restaurant_sales;

	INSERT INTO sa_restaurant_sales.src_restaurant_sales (
		customer_id, 
		customer_full_name, 
		order_id, 
		"timestamp", 
		pizza_type, 
		pizza_name, 
		"size", 
		price, 
		employee_id, 
		employee_full_name, 
		in_or_out,
		quantity,
		load_timestamp
	)
	SELECT 
		e.customer_id, 
		e.customer_full_name, 
		e.order_id, 
		e."timestamp", 
		e.pizza_type, 
		e.pizza_name, 
		e."size", 
		e.price, 
		e.employee_id, 
		e.employee_full_name, 
		e.in_or_out,
		e.quantity,
		current_timestamp 
	FROM 
		sa_restaurant_sales.ext_restaurant_sales_9 e
	WHERE NOT EXISTS (
		SELECT 
			1 
		FROM 
			sa_restaurant_sales.src_restaurant_sales s 
		WHERE 
			COALESCE (s.customer_id, 'N.A.') = COALESCE (e.customer_id, 'N.A.') AND
			COALESCE (s.customer_full_name, 'N.A.') =  COALESCE (e.customer_full_name, 'N.A.') AND
			COALESCE (s.order_id, 'N.A.') = COALESCE (e.order_id, 'N.A.') AND
			COALESCE (s."timestamp", 'N.A.') = COALESCE (e."timestamp", 'N.A.') AND
			COALESCE (s.pizza_type, 'N.A.') = COALESCE (e.pizza_type, 'N.A.') AND
			COALESCE (s.pizza_name, 'N.A.') = COALESCE (e.pizza_name, 'N.A.') AND
			COALESCE (s."size", 'N.A.') = COALESCE (e."size", 'N.A.') AND
			COALESCE (s.price, 'N.A.') = COALESCE (e.price, 'N.A.') AND
			COALESCE (s.employee_id, 'N.A.') = COALESCE (s.employee_id, 'N.A.') AND
			COALESCE (s.employee_full_name, 'N.A.') = COALESCE (s.employee_full_name, 'N.A.') AND
			COALESCE (s.in_or_out, 'N.A.') = COALESCE (e.in_or_out, 'N.A.') AND 
			COALESCE (s.quantity, 'N.A.') = COALESCE (e.quantity, 'N.A.')
	);

	SELECT count(*) INTO count_after FROM sa_restaurant_sales.src_restaurant_sales;
	
	rows_inserted := count_after - count_before;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;
	
--	COMMIT;

END;
$$ LANGUAGE plpgsql; 
