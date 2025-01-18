SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.ce_employees_procedure(
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

    rec RECORD;
    cur CURSOR FOR
        WITH initial_table AS (
            SELECT DISTINCT ON (COALESCE (upper(s.employee_id), 'N.A.'), COALESCE (upper(s.employee_full_name), 'N.A.'))
                COALESCE (upper(s.employee_id), 'N.A.') AS employee_src_id,
                'SA_RESTAURANT_SALES' AS source_system,
                'SRC_RESTAURANT_SALES' AS source_entity,
                COALESCE (upper(s.employee_full_name), 'N.A.') AS employee_full_name,
                current_timestamp AS insert_dt,
                current_timestamp AS update_dt
            FROM 
                sa_restaurant_sales.src_restaurant_sales s
            WHERE NOT EXISTS (
                SELECT 1 FROM bl_3nf.ce_employees t 
                WHERE upper(s.employee_id) = upper(t.employee_src_id) AND 
				upper(t.source_system) = 'SA_RESTAURANT_SALES' AND 
				upper(t.source_entity) = 'SRC_RESTAURANT_SALES' AND
                    upper(s.employee_full_name) = upper(t.employee_full_name)
            ) AND (s.load_timestamp) > (SELECT max(last_src_dt)::timestamp FROM bl_cl.load_metadata lm WHERE src_tablename = 'SRC_RESTAURANT_SALES')
            ORDER BY COALESCE (upper(s.employee_id), 'N.A.'),COALESCE (upper(s.employee_full_name), 'N.A.') DESC
        )
        SELECT * FROM initial_table;
BEGIN 

    username := current_user;
    table_name := 'bl_3nf.ce_employees';
    procedure_name := 'bl_cl.ce_employees_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_3nf.ce_employees;


    OPEN cur;
    
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN NOT FOUND;
        
        BEGIN
            INSERT INTO bl_3nf.ce_employees (
                employee_id,
                employee_src_id,
                source_system,
                source_entity,
                employee_full_name,
                insert_dt,
                update_dt
            ) VALUES (
                nextval('bl_3nf.ce_employees_id_seq'),
                rec.employee_src_id,
                rec.source_system,
                rec.source_entity,
                rec.employee_full_name,
                rec.insert_dt,
                rec.update_dt
            )
            ON CONFLICT (employee_src_id, source_system, source_entity) DO UPDATE
            SET 
                employee_full_name = EXCLUDED.employee_full_name,
                update_dt = EXCLUDED.update_dt;

		rows_aff := rows_aff + 1;

        END;
    END LOOP;
    
    CLOSE cur;

    SELECT count(*) INTO count_after FROM bl_3nf.ce_employees;

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

