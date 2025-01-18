CREATE SCHEMA IF NOT EXISTS bl_dm;

CREATE TABLE IF NOT EXISTS bl_dm.fct_sales (
	customer_surr_id bigint NOT NULL,
	order_surr_id bigint NOT NULL,
	pizza_surr_id bigint NOT NULL,
	event_time varchar(10) NOT NULL,
	address_surr_id bigint NOT NULL,
	event_dt date NOT NULL,
	quantity int NOT NULL,
	price decimal (6,2),
	fct_cost_order decimal (10,2),
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT fct_sales_pk PRIMARY KEY (customer_surr_id, order_surr_id, pizza_surr_id, event_time, event_dt),
	CONSTRAINT sale_customer_fk FOREIGN KEY (customer_surr_id) REFERENCES bl_dm.dim_customers_scd(customer_surr_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_order_fk FOREIGN KEY (order_surr_id) REFERENCES bl_dm.dim_orders(order_surr_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT event_date_fk FOREIGN KEY (event_dt) REFERENCES bl_dm.dim_dates(date_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT event_time_fk FOREIGN KEY (event_time) REFERENCES bl_dm.dim_times(time_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_address_fk FOREIGN KEY (address_surr_id) REFERENCES bl_dm.dim_addresses(address_surr_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_pizza_fk FOREIGN KEY (pizza_surr_id) REFERENCES bl_dm.dim_pizzas(pizza_surr_id) ON UPDATE CASCADE ON DELETE RESTRICT
) PARTITION BY RANGE (event_dt);

-- Creating default partitions (one for default value, second for archived data before the restaurant opening)
CREATE TABLE IF NOT EXISTS bl_dm.fct_sales_default PARTITION OF bl_dm.fct_sales FOR VALUES FROM ('1899-12-31'::date) TO ('1900-01-02'::date);
CREATE TABLE IF NOT EXISTS bl_dm.fct_sales_archived PARTITION OF bl_dm.fct_sales FOR VALUES FROM ('1900-01-02'::date) TO ('2022-05-01'::date);
