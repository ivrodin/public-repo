SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.dim_addresses_procedure(
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
    table_name := 'bl_dm.dim_addresses';
    procedure_name := 'bl_cl.dim_addresses_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_dm.dim_addresses;

	WITH init_table AS (
		SELECT 
			ca.address_id AS address_src_id,
			'BL_3NF' AS source_system,
			'CE_ADDRESSES' AS source_entity ,
			ca.address_name AS address_name,
			ca.district_id AS district_src_id ,
			cd.district_name AS distict_name,
			current_timestamp AS insert_dt,
			current_timestamp AS update_dt
		FROM bl_3nf.ce_addresses ca 
		LEFT JOIN bl_3nf.ce_districts cd ON ca.district_id = cd.district_id 
		WHERE ca.address_id > 0 AND (ca.update_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata)
	)
	INSERT INTO bl_dm.dim_addresses (address_surr_id, address_src_id, source_system, source_entity, address_name, district_src_id, district_name, insert_dt, update_dt)
	SELECT 
		nextval('bl_dm.dim_addresses_surr_id_seq'),
		address_src_id,
		source_system,
		source_entity ,
		address_name,
		district_src_id ,
		distict_name,
		insert_dt,
		update_dt
	FROM init_table s
	WHERE NOT EXISTS (
		SELECT 1 FROM bl_dm.dim_addresses t 
		WHERE upper(t.address_src_id::TEXT) = upper(s.address_src_id::TEXT) AND 
			upper(t.district_src_id::TEXT) = upper(s.district_src_id::TEXT)
	);

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_dm.dim_addresses;

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
