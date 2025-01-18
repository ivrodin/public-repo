CREATE SCHEMA IF NOT EXISTS bl_3nf;

CREATE TABLE IF NOT EXISTS bl_3nf.ce_sales(
	order_id int NOT NULL,
	employee_id int NOT NULL,
	delivery_id int NOT NULL,
	customer_id int NOT NULL,
	address_id int NOT NULL,
	pizza_id int NOT NULL,
	quantity int NOT NULL,
	price decimal(6,2) NOT NULL,
	insert_dt timestamp NOT NULL,
	update_dt timestamp NOT NULL,
	CONSTRAINT sales_pk PRIMARY KEY (order_id, employee_id, delivery_id, customer_id, address_id, pizza_id),
	CONSTRAINT sale_order_fk FOREIGN KEY (order_id) REFERENCES bl_3nf.ce_orders(order_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_pizza_fk FOREIGN KEY (pizza_id) REFERENCES bl_3nf.ce_pizzas(pizza_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_employee_fk FOREIGN KEY (employee_id) REFERENCES bl_3nf.ce_employees(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_delivery_fk FOREIGN KEY (delivery_id) REFERENCES bl_3nf.ce_deliveries(delivery_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT sale_address_fk FOREIGN KEY (address_id) REFERENCES bl_3nf.ce_addresses(address_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
