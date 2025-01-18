CREATE TABLE dilab_student1300.dim_pizzas (
	pizza_surr_id bigint,
	pizza_src_id varchar(255),
	source_system varchar(255),
	source_entity varchar(255),
	pizza_name varchar(255),
	pizza_type_src_id int,
	pizza_type_name varchar(255),
	pizza_size_src_id int,
	pizza_size_name varchar(255),
	insert_dt timestamp,
	update_dt timestamp,
	CONSTRAINT dim_pizzas_pkey PRIMARY KEY (pizza_surr_id)
);

CREATE TABLE dilab_student1300.dim_dates (
	date_id date,
	date_year int,
	date_month int,
	date_monthname varchar(255),
	date_monthday int,
	date_yearday int,
	date_weekdayname varchar(255),
	date_calendarweek int,
	date_formatteddate varchar(255),
	date_quarter varchar(255),
	date_yearquarter varchar(255),
	date_yearmonth varchar(255),
	date_yearcalendarweek varchar(255),
	date_weekend varchar(255),
	date_georgianholiday varchar(255),
	date_period varchar(255),
	date_cwstart date,
	date_cwend date,
	date_monthstart date,
	date_monthend timestamp,
	CONSTRAINT dim_dates_pkey PRIMARY KEY (date_id)
);

CREATE TABLE dilab_student1300.fct_sales (
	customer_surr_id bigint,
	order_surr_id bigint,
	pizza_surr_id bigint,
	event_time varchar(255),
	address_surr_id bigint,
	event_dt date,
	quantity int,
	price decimal(6,2),
	fct_cost_order decimal(10,2),
	insert_dt timestamp,
	update_dt timestamp,
	CONSTRAINT fct_sales_pk PRIMARY KEY (customer_surr_id, order_surr_id, pizza_surr_id, event_time, event_dt)
);

copy dilab_student1300.dim_dates (
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
	date_monthend)
from 's3://rodinivanbucket/pizzaplace_dwh/schema_bl_dm/dim_dates/dim_dates.csv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
IGNOREHEADER 1;

SELECT * FROM dilab_student1300.dim_dates LIMIT 10;

copy dilab_student1300.fct_sales(	
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
	update_dt)
from 's3://rodinivanbucket/pizzaplace_dwh/schema_bl_dm/fct_sales/fct_sales.csv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
IGNOREHEADER 1;

SELECT * FROM dilab_student1300.fct_sales LIMIT 10;

copy dilab_student1300.dim_pizzas(	
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
	update_dt)
from 's3://rodinivanbucket/pizzaplace_dwh/schema_bl_dm/dim_pizzas/dim_pizzas.csv'
credentials
'aws_iam_role=arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
delimiter ','
csv
IGNOREHEADER 1;


SELECT "column", "type", encoding , "sortkey"
FROM pg_table_def 
WHERE tablename = 'dim_dates' 
AND schemaname = 'dilab_student1300';

SELECT "column", "type", encoding , "sortkey"
FROM pg_table_def 
WHERE tablename = 'dim_pizzas' 
AND schemaname = 'dilab_student1300';

SELECT "column", "type", encoding , "sortkey"
FROM pg_table_def 
WHERE tablename = 'fct_sales' 
AND schemaname = 'dilab_student1300';

SELECT "column"
FROM pg_table_def 
WHERE tablename = 'fct_sales' 
AND schemaname = 'dilab_student1300' AND 
"sortkey" = 1;



SELECT "table", diststyle 
FROM svv_table_info 
WHERE "table" = 'dim_dates'
AND schema = 'dilab_student1300';

SELECT "table", diststyle 
FROM svv_table_info 
WHERE "table" = 'fct_sales'
AND schema = 'dilab_student1300';

SELECT "table", diststyle 
FROM svv_table_info 
WHERE "table" = 'dim_pizzas' 
AND schema = 'dilab_student1300';



ANALYZE COMPRESSION fct_sales;




CREATE TABLE dilab_student1300.fct_sales_defaultcomp (
	customer_surr_id bigint ENCODE AZ64,
	order_surr_id bigint ENCODE AZ64,
	pizza_surr_id bigint ENCODE AZ64,
	event_time varchar(255) ENCODE LZO,
	address_surr_id bigint ENCODE AZ64,
	event_dt date ENCODE AZ64,
	quantity int ENCODE AZ64,
	price decimal(6,2) ENCODE AZ64,
	fct_cost_order decimal(10,2) ENCODE AZ64,
	insert_dt timestamp ENCODE AZ64,
	update_dt timestamp ENCODE AZ64
);

CREATE TABLE dilab_student1300.fct_sales_withoutcomp (
	customer_surr_id bigint ENCODE RAW,
	order_surr_id bigint ENCODE RAW,
	pizza_surr_id bigint ENCODE RAW,
	event_time varchar(255) ENCODE RAW,
	address_surr_id bigint ENCODE RAW,
	event_dt date ENCODE RAW,
	quantity int ENCODE RAW,
	price decimal(6,2) ENCODE RAW,
	fct_cost_order decimal(10,2) ENCODE RAW,
	insert_dt timestamp ENCODE RAW,
	update_dt timestamp ENCODE RAW
);

CREATE TABLE dilab_student1300.fct_sales_analyzedcomp (
	customer_surr_id bigint ENCODE AZ64,
	order_surr_id bigint ENCODE AZ64,
	pizza_surr_id bigint ENCODE AZ64,
	event_time varchar(255) ENCODE ZSTD,
	address_surr_id bigint ENCODE AZ64,
	event_dt date ENCODE AZ64,
	quantity int ENCODE AZ64,
	price decimal(6,2) ENCODE AZ64,
	fct_cost_order decimal(10,2) ENCODE AZ64,
	insert_dt timestamp ENCODE AZ64,
	update_dt timestamp ENCODE AZ64
);

INSERT INTO dilab_student1300.fct_sales_withoutcomp(	
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
SELECT * FROM dilab_student1300.fct_sales;

INSERT INTO dilab_student1300.fct_sales_defaultcomp(	
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
SELECT * FROM dilab_student1300.fct_sales;

INSERT INTO dilab_student1300.fct_sales_analyzedcomp (	
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
SELECT * FROM dilab_student1300.fct_sales;



SELECT
    "table",
    SUM(size) AS total_size_mb
FROM
    svv_table_info
WHERE
    schema = 'dilab_student1300'
    AND "table" = 'fct_sales_withoutcomp'
    OR "table" = 'fct_sales_defaultcomp'
    OR "table" = 'fct_sales_analyzedcomp'
GROUP BY
    "table";

   

CREATE OR REPLACE PROCEDURE dilab_student1300.main_procedure()
LANGUAGE plpgsql
AS $$
DECLARE
	execution_time text;
	fct_sales_dist_style text;
	dim_pizzas_dist_style text;
	dim_dates_dist_style text;
BEGIN
	-- turning off cashing
	 EXECUTE 'SET enable_result_cache_for_session TO off';
	
	-- executing query
    EXECUTE '
        SELECT dp.pizza_name, dp.pizza_size_name, sum(fs2.quantity) AS quantity_sold
        FROM dilab_student1300.fct_sales fs2
        LEFT JOIN dilab_student1300.dim_dates dd ON fs2.event_dt = dd.date_id
        LEFT JOIN dilab_student1300.dim_pizzas dp ON fs2.pizza_surr_id = dp.pizza_surr_id
        WHERE dd.date_monthday < 15 AND upper(dp.pizza_type_name) = ''CLASSIC''
		AND upper(dd.date_weekdayname) = ''FRIDAY''
        GROUP BY dp.pizza_name, dp.pizza_size_name
        ORDER BY quantity_sold DESC';
	
	-- evaluating time of execution
	SELECT
	    EXTRACT(EPOCH FROM (sq.endtime - sq.starttime)) INTO execution_time
	FROM stl_query sq
	WHERE sq.query = pg_last_query_id() AND sq.userid = 272;

	-- getting additional measures (dist and sort)
	SELECT diststyle into dim_dates_dist_style
	FROM svv_table_info 
	WHERE "table" = 'dim_dates'
	AND schema = 'dilab_student1300';
	
	SELECT diststyle into fct_sales_dist_style
	FROM svv_table_info 
	WHERE "table" = 'fct_sales'
	AND schema = 'dilab_student1300';
	
	SELECT diststyle into dim_pizzas_dist_style
	FROM svv_table_info 
	WHERE "table" = 'dim_pizzas' 
	AND schema = 'dilab_student1300';

	-- printing out measures for reporting
	RAISE NOTICE 'Query execution time: % seconds', execution_time;
	RAISE NOTICE 'dim_pizzas Distribution style: %', dim_pizzas_dist_style;
	RAISE NOTICE 'dim_dates Distribution style: %', dim_dates_dist_style;
	RAISE NOTICE 'fct_sales Distribution style: %', fct_sales_dist_style;
	
END;
$$;

CALL dilab_student1300.main_procedure();

EXPLAIN 
SELECT dp.pizza_name, dp.pizza_size_name, sum(fs2.quantity) AS quantity_sold 
FROM dilab_student1300.fct_sales fs2 
LEFT JOIN dilab_student1300.dim_dates dd ON fs2.event_dt = dd.date_id 
LEFT JOIN dilab_student1300.dim_pizzas dp ON fs2.pizza_surr_id = dp.pizza_surr_id 
WHERE dd.date_monthday > 15 AND upper(dp.pizza_type_name) = 'CLASSIC'
AND upper(dd.date_weekdayname) = 'FRIDAY'
GROUP BY dp.pizza_name ,dp.pizza_size_name
ORDER BY quantity_sold Desc;

ALTER TABLE dilab_student1300.dim_dates ALTER DISTSTYLE ALL;
ALTER TABLE dilab_student1300.dim_pizzas ALTER DISTSTYLE ALL;
ALTER TABLE dilab_student1300.fct_sales ALTER DISTSTYLE KEY DISTKEY pizza_surr_id;

ALTER TABLE dilab_student1300.dim_dates ALTER SORTKEY (date_id);
ALTER TABLE dilab_student1300.dim_pizzas ALTER SORTKEY (pizza_surr_id);
ALTER TABLE dilab_student1300.fct_sales ALTER SORTKEY (event_dt, pizza_surr_id);




-- COPY 

CREATE TABLE dilab_student1300.lineorder_1 (
	lo_orderkey INTEGER NOT NULL,
	lo_linenumber INTEGER NOT NULL,
	lo_custkey INTEGER NOT NULL,
	lo_partkey INTEGER NOT NULL,
	lo_suppkey INTEGER NOT NULL,
	lo_orderdate INTEGER NOT NULL,
	lo_orderpriority VARCHAR(15) NOT NULL,
	lo_shippriority VARCHAR(1) NOT NULL,
	lo_quantity INTEGER NOT NULL,
	lo_extendedprice INTEGER NOT NULL,
	lo_ordertotalprice INTEGER NOT NULL,
	lo_discount INTEGER NOT NULL,
	lo_revenue INTEGER NOT NULL,
	lo_supplycost INTEGER NOT NULL,
	lo_tax INTEGER NOT NULL,
	lo_commitdate INTEGER NOT NULL,
	lo_shipmode VARCHAR(10) NOT NULL
);

CREATE TABLE dilab_student1300.lineorder_2 (
	lo_orderkey INTEGER NOT NULL,
	lo_linenumber INTEGER NOT NULL,
	lo_custkey INTEGER NOT NULL,
	lo_partkey INTEGER NOT NULL,
	lo_suppkey INTEGER NOT NULL,
	lo_orderdate INTEGER NOT NULL,
	lo_orderpriority VARCHAR(15) NOT NULL,
	lo_shippriority VARCHAR(1) NOT NULL,
	lo_quantity INTEGER NOT NULL,
	lo_extendedprice INTEGER NOT NULL,
	lo_ordertotalprice INTEGER NOT NULL,
	lo_discount INTEGER NOT NULL,
	lo_revenue INTEGER NOT NULL,
	lo_supplycost INTEGER NOT NULL,
	lo_tax INTEGER NOT NULL,
	lo_commitdate INTEGER NOT NULL,
	lo_shipmode VARCHAR(10) NOT NULL
);

copy dilab_student1300.lineorder_1 (
  lo_orderkey,
  lo_linenumber,
  lo_custkey,
  lo_partkey,
  lo_suppkey,
  lo_orderdate,
  lo_orderpriority,
  lo_shippriority,
  lo_quantity,
  lo_extendedprice,
  lo_ordertotalprice,
  lo_discount,
  lo_revenue,
  lo_supplycost,
  lo_tax,
  lo_commitdate,
  lo_shipmode)
from 's3://dilabbucket/files/lineorder_file/'
IAM_ROLE 'arn:aws:iam::260586643565:role/dilab-redshift-role'
region 'eu-central-1'
format AS CSV
GZIP
delimiter ',';


copy dilab_student1300.lineorder_2 (
  lo_orderkey,
  lo_linenumber,
  lo_custkey,
  lo_partkey,
  lo_suppkey,
  lo_orderdate,
  lo_orderpriority,
  lo_shippriority,
  lo_quantity,
  lo_extendedprice,
  lo_ordertotalprice,
  lo_discount,
  lo_revenue,
  lo_supplycost,
  lo_tax,
  lo_commitdate,
  lo_shipmode)
from 's3://dilabbucket/files/lineorders/'
IAM_ROLE 'arn:aws:iam::260586643565:role/dilab-redshift-role'
FORMAT AS PARQUET;






-- EXTERNAL TABLES AND PARTITIONS

CREATE EXTERNAL SCHEMA if not exists user_dilab_student1300_ext
FROM DATA catalog
DATABASE 'pizzaplace_rodin_db'
IAM_ROLE 'arn:aws:iam::260586643565:role/dilab-redshift-role';

CREATE OR REPLACE PROCEDURE dilab_student1300.export_data_by_month()
LANGUAGE plpgsql
AS $$
DECLARE
    record_month RECORD;
    base_s3_path TEXT := 's3://rodinivanbucket/task_3_redshift/';
    unload_sql VARCHAR(500);
BEGIN
    -- Get distinct months from the table
    FOR record_month IN
        SELECT DISTINCT to_char(event_dt, 'YYYY-MM') AS month
        FROM dilab_student1300.fct_sales
    LOOP
		unload_sql := 
		    'UNLOAD (''SELECT * FROM dilab_student1300.fct_sales WHERE to_char(event_dt, ''''YYYY-MM'''') = ''''' || 
		    record_month.month || ''''' '') ' ||
		    'TO ''s3://rodinivanbucket/task_3_redshift/' || record_month.month || '/' || record_month.month ||'.csv'' '||
		    'IAM_ROLE ''arn:aws:iam::260586643565:role/dilab-redshift-role'' ' ||
            'ALLOWOVERWRITE ' ||
            'PARALLEL OFF ' || 
		    'DELIMITER AS '','' ' ||
		    'FORMAT AS CSV;';
        EXECUTE unload_sql;
    END LOOP;
END $$;

CALL dilab_student1300.export_data_by_month();

CREATE EXTERNAL TABLE user_dilab_student1300_ext.ext_student1300_partitioned (
	customer_surr_id bigint,
	order_surr_id bigint,
	pizza_surr_id bigint,
	event_time varchar(255),
	address_surr_id bigint,
	event_dt date,
	quantity int,
	price decimal(6,2),
	fct_cost_order decimal(10,2),
	insert_dt timestamp,
	update_dt timestamp
)
PARTITIONED BY (saledate char(10))
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://rodinivanbucket/pizzaplace_dwh/schema_bl_dm/fct_sales/';

SELECT * FROM user_dilab_student1300_ext.ext_student1300_partitioned;

ALTER TABLE user_dilab_student1300_ext.ext_student1300_partitioned ADD 
PARTITION (saledate='2022-07') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2022-07/'
PARTITION (saledate='2022-08') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2022-08/'
PARTITION (saledate='2022-09') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2022-09/'
PARTITION (saledate='2022-10') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2022-10/'
PARTITION (saledate='2022-11') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2022-11/'
PARTITION (saledate='2022-12') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2022-12/'
PARTITION (saledate='2023-01') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-01/'
PARTITION (saledate='2023-02') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-02/'
PARTITION (saledate='2023-03') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-03/'
PARTITION (saledate='2023-04') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-04/'
PARTITION (saledate='2023-05') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-05/'
PARTITION (saledate='2023-06') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-06/'
PARTITION (saledate='2023-07') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-07/'
PARTITION (saledate='2023-08') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-08/'
PARTITION (saledate='2023-09') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-09/'
PARTITION (saledate='2023-10') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-10/'
PARTITION (saledate='2023-11') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-11/'
PARTITION (saledate='2023-12') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2023-12/'
PARTITION (saledate='2024-01') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2024-01/'
PARTITION (saledate='2024-02') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2024-02/'
PARTITION (saledate='2024-03') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2024-03/'
PARTITION (saledate='2024-04') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2024-04/'
PARTITION (saledate='2024-05') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2024-05/'
PARTITION (saledate='2024-06') 
LOCATION 's3://rodinivanbucket/task_3_redshift/2024-06/'
;
SELECT * FROM svv_external_partitions;


CREATE OR REPLACE PROCEDURE dilab_student1300.partitions_check()
LANGUAGE plpgsql
AS $$
DECLARE
    count_fct_sales int;
    count_ext_table int;
    curr_date date := '2022-07-01'::date;
    end_date date := '2024-06-30'::date;
BEGIN
    LOOP
        SELECT count(*) 
        INTO count_fct_sales 
        FROM user_dilab_student1300_ext.fct_sales fs2 
        WHERE extract(YEAR FROM event_dt::date) = extract(YEAR FROM curr_date)
        AND extract(MONTH FROM event_dt::date) = extract(MONTH FROM curr_date);

        SELECT count(*) 
        INTO count_ext_table 
        FROM user_dilab_student1300_ext.ext_student1300_partitioned esp 
        WHERE saledate = to_char(curr_date, 'YYYY-MM');

        IF count_fct_sales - count_ext_table != 0 THEN
            RAISE NOTICE 'Check Failed for date %', curr_date;
            EXIT;
		ELSE 
			RAISE NOTICE 'Check Passed for date %', curr_date;
        END IF;

        curr_date := curr_date + interval '1 month';

        EXIT WHEN curr_date > end_date;
    END LOOP;
END $$;

CALL dilab_student1300.partitions_check();


