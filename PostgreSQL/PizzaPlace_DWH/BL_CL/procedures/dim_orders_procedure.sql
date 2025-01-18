SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.dim_orders_procedure(
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
    rows_aff INT := 0;
    order_rec bl_dm.order_record_type;
    row_cursor CURSOR FOR
		SELECT DISTINCT
		    COALESCE(co.order_id, -1) AS order_src_id,
		    'BL_3NF' AS source_system,
		    'CE_ORDERS' AS source_entity,
		    COALESCE(order_src_id, 'N.A.') AS order_name,
		    COALESCE(cs.employee_id, -1) AS employee_src_id,
		    COALESCE(ce.employee_full_name, 'N.A.') AS employee_full_name,
		    co.order_type AS order_type,
		    co.offline_order_type AS offline_order_type,
		    COALESCE(cs.delivery_id, -1) AS delivery_src_id,
		    COALESCE(cd.delivery_name, 'N.A.') AS delivery_name,
		    COALESCE(cd.courier_id, -1) AS courier_src_id,
		    COALESCE(cc.courier_full_name, 'N.A.') AS courier_full_name,
		    current_timestamp AS insert_dt,
		    current_timestamp AS update_dt
		FROM bl_3nf.ce_orders co
		LEFT JOIN bl_3nf.ce_sales cs ON co.order_id = cs.order_id
		LEFT JOIN bl_3nf.ce_deliveries cd ON cs.delivery_id = cd.delivery_id
		LEFT JOIN bl_3nf.ce_couriers cc ON cd.courier_id = cc.courier_id
		LEFT JOIN bl_3nf.ce_employees ce ON cs.employee_id = ce.employee_id
		WHERE NOT EXISTS (
		    SELECT 1 FROM bl_dm.dim_orders t
		    WHERE upper(co.order_id::TEXT) = upper(t.order_src_id::TEXT) AND 
		        upper(co.order_type::TEXT) = upper(t.order_type::TEXT) AND 
		        upper(co.order_src_id::TEXT) = upper(t.order_name::TEXT) AND 
		        COALESCE(cs.employee_id, -1)::text = t.employee_src_id AND 
		        COALESCE(ce.employee_full_name, 'N.A.') = t.employee_full_name AND 
		        co.order_type::text = t.order_type AND 
		        co.offline_order_type::text = t.offline_order_type AND 
		        COALESCE(cs.delivery_id, -1)::text = t.delivery_src_id AND 
		        COALESCE(cd.delivery_name, 'N.A.') = t.delivery_name AND
		        COALESCE(cd.courier_id, -1)::text = t.courier_src_id AND 
		        COALESCE(cc.courier_full_name, 'N.A.') = t.courier_full_name
		) AND co.order_id > 0 AND (co.update_dt) > (SELECT max(load_dt) FROM bl_cl.load_metadata);
BEGIN 

	username := current_user;
    table_name := 'bl_dm.dim_orders';
    procedure_name := 'bl_cl.dim_orders_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_dm.dim_orders;

    OPEN row_cursor;

    LOOP
        FETCH row_cursor INTO order_rec;
        EXIT WHEN NOT FOUND;

        INSERT INTO bl_dm.dim_orders(order_surr_id, order_src_id, source_system, source_entity, order_name, employee_src_id, employee_full_name, order_type, offline_order_type, delivery_src_id, delivery_name, courier_src_id, courier_full_name, insert_dt, update_dt)
        VALUES (
            nextval('bl_dm.dim_orders_surr_id_seq'),
            order_rec.order_src_id, 
            order_rec.source_system, 
            order_rec.source_entity, 
            order_rec.order_name, 
            order_rec.employee_src_id, 
            order_rec.employee_full_name, 
            order_rec.order_type, 
            order_rec.offline_order_type, 
            order_rec.delivery_src_id, 
            order_rec.delivery_name, 
            order_rec.courier_src_id, 
            order_rec.courier_full_name, 
            order_rec.insert_dt, 
            order_rec.update_dt
        )	
		ON CONFLICT (order_src_id, source_system, source_entity) DO UPDATE
		SET 
		    update_dt = EXCLUDED.update_dt,
			order_name = EXCLUDED.order_name,
			employee_src_id = EXCLUDED.employee_src_id,
			employee_full_name = EXCLUDED.employee_full_name,
			order_type = EXCLUDED.order_type,
			offline_order_type = EXCLUDED.offline_order_type,
			delivery_src_id = EXCLUDED.delivery_src_id,
			delivery_name = EXCLUDED.delivery_name,
			courier_src_id = EXCLUDED.courier_src_id,
			courier_full_name = EXCLUDED.courier_full_name;

	rows_aff := rows_aff + 1;

    END LOOP;

    CLOSE row_cursor;

    SELECT count(*) INTO count_after FROM bl_dm.dim_orders;

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
