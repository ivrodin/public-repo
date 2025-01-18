/*Creating manager role with access to schema and SELECT privileges on all the tables in my_museum schema*/

DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'manager') THEN 
        CREATE ROLE manager LOGIN PASSWORD 'managerpassword'; 
    END IF; 
END $$;

GRANT USAGE ON SCHEMA my_museum TO manager;

GRANT SELECT ON ALL TABLES IN SCHEMA my_museum TO manager;