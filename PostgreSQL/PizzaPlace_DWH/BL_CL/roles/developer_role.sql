DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'developer_role') THEN
      CREATE ROLE developer_role WITH LOGIN PASSWORD 'developerpassword';
   END IF;
END $$;

GRANT USAGE ON SCHEMA sa_online_sales TO developer_role;
GRANT CREATE ON SCHEMA sa_online_sales TO developer_role;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA sa_online_sales TO developer_role;

ALTER TABLE bl_dm.fct_sales OWNER TO developer_role;

GRANT USAGE ON SCHEMA sa_restaurant_sales TO developer_role;
GRANT CREATE ON SCHEMA sa_restaurant_sales TO developer_role;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA sa_restaurant_sales TO developer_role;
	
GRANT USAGE ON SCHEMA bl_cl TO developer_role;
GRANT CREATE ON SCHEMA bl_cl TO developer_role;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA bl_cl TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_cl.lkp_pizzas_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_cl.lkp_pizzas_types_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_cl.lkp_pizzas_sizes_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_cl.load_meadata_id_seq TO developer_role;


GRANT USAGE ON SCHEMA bl_3nf TO developer_role;
GRANT CREATE ON SCHEMA bl_3nf TO developer_role;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA bl_3nf TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_couriers_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_deliveries_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_customers_scd_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_districts_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_addresses_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_employees_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_pizzas_types_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_pizzas_sizes_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_pizzas_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_3nf.ce_orders_id_seq TO developer_role;


GRANT USAGE ON SCHEMA bl_dm TO developer_role;
GRANT CREATE ON SCHEMA bl_dm TO developer_role;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA bl_dm TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_dm.dim_orders_surr_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_dm.dim_addresses_surr_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_dm.dim_customers_scd_surr_id_seq TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE bl_dm.dim_pizzas_surr_id_seq TO developer_role;
