SET ROLE developer_role;

CREATE OR REPLACE FUNCTION bl_cl.procedures_to_log()
RETURNS TABLE (
    username name,
    table_name text,
    procedure_name text,
    rows_updated int,
    rows_inserted int,
    procedure_timestamp text,
    status text
) AS $$
DECLARE
    v_username name;
    v_table_name text;
    v_procedure_name text;
    v_rows_updated int;
    v_rows_inserted int;
    v_procedure_timestamp text;
    v_status text;
    v_procedures text[] := ARRAY[
		'bl_cl.src_online_sales_procedure',
		'bl_cl.src_restaurant_sales_procedure',
		'bl_cl.rolling_window_partitions',
		'bl_cl.default_rows_procedure',
        'bl_cl.lkp_pizzas_sizes_procedure',
        'bl_cl.lkp_pizzas_procedure',
        'bl_cl.lkp_pizzas_types_procedure',
        'bl_cl.ce_couriers_procedure',
        'bl_cl.ce_deliveries_procedure',
        'bl_cl.ce_customers_scd_procedure',
        'bl_cl.ce_districts_procedure',
        'bl_cl.ce_addresses_procedure',
        'bl_cl.ce_employees_procedure',
        'bl_cl.ce_pizzas_types_procedure',
        'bl_cl.ce_pizzas_sizes_procedure',
        'bl_cl.ce_pizzas_procedure',
        'bl_cl.ce_orders_procedure',
		'bl_cl.ce_sales_procedure',
		'bl_cl.dim_times_procedure',
		'bl_cl.dim_dates_procedure',
        'bl_cl.dim_addresses_procedure',
        'bl_cl.dim_pizzas_procedure',
        'bl_cl.dim_customers_scd_procedure',
        'bl_cl.dim_orders_procedure',
		'bl_cl.fct_sales_procedure',
		'bl_cl.upd_load_metadata'
    ];
BEGIN

    FOREACH v_procedure_name IN ARRAY v_procedures
    LOOP
        BEGIN
            EXECUTE format('CALL %s($1, $2, $3, $4, $5, $6, $7)', v_procedure_name)
            INTO v_username, v_table_name, v_procedure_name, v_rows_updated, v_rows_inserted, v_procedure_timestamp, v_status
            USING v_username, v_table_name, v_procedure_name, v_rows_updated, v_rows_inserted, v_procedure_timestamp, v_status;

            RETURN QUERY SELECT v_username, v_table_name, v_procedure_name, v_rows_updated, v_rows_inserted, v_procedure_timestamp, v_status;

        END;
    END LOOP;

END;
$$ LANGUAGE plpgsql;
