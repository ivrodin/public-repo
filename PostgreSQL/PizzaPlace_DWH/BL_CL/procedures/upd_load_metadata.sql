SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.upd_load_metadata (
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
    count_before INT;
    count_after INT;
BEGIN 

    username := current_user;
    table_name := 'bl_cl.load_metadata';
    procedure_name := 'bl_cl.upd_load_metadata';
    procedure_starttime := current_timestamp::text;
	status := 'Success';
	rows_updated := 0;

    SELECT count(*) INTO count_before FROM bl_cl.load_metadata;	
		
	INSERT INTO bl_cl.load_metadata (load_id, src_tablename, last_src_dt, load_dt)
	SELECT nextval('bl_cl.load_meadata_id_seq'), 
		'SRC_ONLINE_SALES', 
		(SELECT max(sos.load_timestamp) FROM sa_online_sales.src_online_sales sos),
		current_timestamp
	UNION ALL
	SELECT nextval('bl_cl.load_meadata_id_seq'), 
		'SRC_RESTAURANT_SALES',
		(SELECT max(sos.load_timestamp) FROM sa_restaurant_sales.src_restaurant_sales sos),
		current_timestamp;

    SELECT count(*) INTO count_after FROM bl_cl.load_metadata;

	rows_inserted := count_after - count_before;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;

END;
$$ LANGUAGE plpgsql;
