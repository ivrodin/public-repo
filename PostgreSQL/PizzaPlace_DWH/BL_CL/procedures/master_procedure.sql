SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.master_procedure()
AS $$
BEGIN 

	INSERT INTO bl_cl.procedure_log (
		username,
		table_name,
		procedure_name,
		rows_updated,
		rows_inserted,
		procedure_timestamp,
		status
	)
	SELECT username, table_name, procedure_name, rows_updated, rows_inserted, procedure_timestamp, status FROM bl_cl.procedures_to_log();

END;
$$ LANGUAGE plpgsql;

