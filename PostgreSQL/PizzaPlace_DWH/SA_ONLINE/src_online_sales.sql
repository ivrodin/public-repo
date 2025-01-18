CREATE SCHEMA IF NOT EXISTS sa_restaurant_sales;

CREATE TABLE IF NOT EXISTS sa_online_sales.src_online_sales (
	customer_id varchar(255),
	customer_full_name varchar(255),
	order_id varchar(255),
	timestamp varchar(255),
	pizza_type varchar(255),
	pizza_name varchar(255),
	size varchar(255),
	price varchar(255),
	delivery_id varchar(255),
	delivery_name varchar(255),
	courier_id varchar(255),
	courier_full_name varchar(255),
	district varchar(255),
	address varchar(255),
	quantity varchar(255),
	load_timestamp timestamp
);
