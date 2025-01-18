SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.rolling_window_partitions(
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
	rows_before int;
	rows_after int;

    max_date_src date;
    min_date_src date;

	partition_name text;	

    last_partition_end_date date;
    next_partition_end_date date;
    cutoff_date date;
    old_partition_name text;
BEGIN

    username := current_user;
    table_name := 'bl_dm.fct_sales';
    procedure_name := 'bl_cl.rolling_window_partitions';
    procedure_starttime := current_timestamp::text;
	status := 'Success';
	rows_updated := 0;
	
    SELECT count(*) INTO rows_before FROM pg_class WHERE relname ~ '^fct_sales_from_'; 

	WITH unified_dates AS (
		SELECT max(TO_DATE(sos."timestamp", 'DD-MM-YY')) AS max_dt 
		FROM sa_online_sales.src_online_sales sos
		UNION ALL
		SELECT max(TO_DATE(srs."timestamp", 'DD-MM-YY')) AS max_dt 
		FROM sa_restaurant_sales.src_restaurant_sales srs
	)
	SELECT max(max_dt) INTO max_date_src FROM unified_dates;

    SELECT
        COALESCE((regexp_replace(
            pg_get_expr(c.relpartbound, c.oid), 
            'FOR VALUES FROM \((.*)\) TO \((.*)\)', 
            '\2')::date), '2022-01-01'::date)
		INTO last_partition_end_date
    FROM
        pg_class c
    WHERE
        c.relname ~ '^fct_sales_' 
    ORDER BY 
        last_partition_end_date DESC 
    LIMIT 1;

    WHILE last_partition_end_date <= max_date_src LOOP
        next_partition_end_date  := last_partition_end_date + INTERVAL '2 months';
        partition_name := 'fct_sales_from_' || TO_CHAR(last_partition_end_date, 'YYYY_MM') || '_to_' || TO_CHAR(next_partition_end_date, 'YYYY_MM');

        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS bl_dm.%I PARTITION OF bl_dm.fct_sales FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            last_partition_end_date,
            next_partition_end_date
        );

        last_partition_end_date := next_partition_end_date;
    END LOOP;

    SELECT count(*) INTO rows_after FROM pg_class WHERE relname ~ '^fct_sales_from_'; 

	rows_inserted := (rows_after - rows_before)/2;


EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;
END;
$$ LANGUAGE plpgsql;
