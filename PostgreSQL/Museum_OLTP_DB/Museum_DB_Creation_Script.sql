/*Creating database*/ 

CREATE EXTENSION IF NOT EXISTS dblink;

DO $$
BEGIN 
	IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'cultural_facilities') THEN
		/*Insert your user and password for this code to work properly (establish your connection)*/
		PERFORM dblink_connect('host=localhost user=postgres password=1234 dbname=' || current_database());
		PERFORM dblink_exec('CREATE DATABASE cultural_facilities');
		PERFORM dblink_disconnect();
	END IF;
END$$;
