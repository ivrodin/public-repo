SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.fct_sales_procedure(
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
    table_name := 'bl_dm.fct_sales';
    procedure_name := 'bl_cl.fct_sales_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_dm.fct_sales;

    WITH init_table AS (
        SELECT 
            COALESCE (do2.order_surr_id, -1) AS order_surr_id,
            COALESCE (cs.customer_surr_id, -1) AS customer_surr_id,
            COALESCE (dp.pizza_surr_id, -1) AS pizza_surr_id,
            COALESCE (da.address_surr_id, -1) AS address_surr_id, 
            COALESCE (dd.date_id, '1900-01-01'::date) AS event_dt,
			CASE 
				WHEN COALESCE (dd.date_id, '1900-01-01'::date) = '1900-01-01'::date THEN 'N.A.'
				ELSE COALESCE (dt.time_id, 'N.A.')
			END AS event_time,
			COALESCE (co.quantity, 0) as quantity,
            COALESCE (co.price, 0) AS price,
			(co.quantity * co.price) AS fct_cost_order,
            current_timestamp AS insert_dt,
            current_timestamp AS update_dt
        FROM bl_3nf.ce_sales co
		LEFT JOIN bl_3nf.ce_orders css ON co.order_id = css.order_id
        LEFT JOIN bl_dm.dim_orders do2 ON do2.order_src_id = co.order_id::text
            AND upper(do2.source_system) = 'BL_3NF' AND upper(do2.source_entity) = 'CE_ORDERS'
        LEFT JOIN bl_dm.dim_customers_scd cs ON upper(cs.customer_src_id) = upper(co.customer_id::text)
            AND upper(cs.original_source) = upper(css.order_type::TEXT) AND upper(cs.is_active) = 'Y'
            AND upper(cs.source_system) = 'BL_3NF' AND upper(cs.source_entity) = 'CE_CUSTOMERS_SCD'
        LEFT JOIN bl_dm.dim_pizzas dp ON upper(dp.pizza_src_id) = upper(co.pizza_id::text)
            AND upper(dp.source_system) = 'BL_3NF' AND upper(dp.source_entity) = 'CE_PIZZAS'
        LEFT JOIN bl_dm.dim_addresses da ON upper(da.address_src_id) = upper(co.address_id::text)
            AND upper(da.source_system) = 'BL_3NF' AND upper(da.source_entity) = 'CE_ADDRESSES'
        LEFT JOIN bl_dm.dim_dates dd ON css.order_timestamp::date = dd.date_id
        LEFT JOIN bl_dm.dim_times dt ON TO_CHAR(css.order_timestamp::time, 'HH24:MI') = dt.time_id
        WHERE (co.update_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
    )
    INSERT INTO bl_dm.fct_sales (
        customer_surr_id,
        order_surr_id,
        pizza_surr_id,
        event_time,
        address_surr_id,
        event_dt,
		quantity,
        price,
        fct_cost_order,
        insert_dt,
        update_dt
    )
    SELECT     
        customer_surr_id,
        order_surr_id,
        pizza_surr_id,
        event_time,
        address_surr_id,
        event_dt,
		quantity,
        price,
        fct_cost_order,
        insert_dt,
        update_dt
    FROM init_table;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_dm.fct_sales;

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
