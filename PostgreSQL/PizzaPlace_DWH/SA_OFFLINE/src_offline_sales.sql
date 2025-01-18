CREATE SCHEMA IF NOT EXISTS sa_restaurant_sales;

CREATE TABLE IF NOT EXISTS sa_restaurant_sales.src_restaurant_sales (
	customer_id varchar(255),
	customer_full_name varchar(255),
	order_id varchar(255),
	timestamp varchar(255),
	pizza_type varchar(255),
	pizza_name varchar(255),
	size varchar(255),
	price varchar(255),
	employee_id varchar(255),
	employee_full_name varchar(255),
	in_or_out varchar(255),
	quantity varchar(255),
	load_timestamp timestamp
);
