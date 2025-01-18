CREATE SCHEMA IF NOT EXISTS bl_cl;

CREATE TABLE IF NOT EXISTS bl_cl.procedure_log (
	username name NOT NULL,
	table_name varchar(255) NOT NULL,
	procedure_name varchar(255) NOT NULL,
	rows_updated int NOT NULL,
	rows_inserted int NOT NULL,
	procedure_timestamp varchar(50) NOT NULL,
	status varchar(255) NOT NULL
);
