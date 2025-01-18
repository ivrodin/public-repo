/*Creating functions*/

CREATE OR REPLACE FUNCTION my_museum.my_exhibitions_table_updater (prim_key int, col_name TEXT, new_val TEXT)
RETURNS void AS $$
BEGIN 
	IF col_name = 'exhibition_start_date' OR col_name = 'exhibition_end_date' THEN 
		EXECUTE ('UPDATE my_museum.exhibitions SET ' || quote_ident(col_name) || ' = '|| quote_literal(new_val::timestamptz) || ' WHERE exhibition_id = ' || prim_key ||';');
	ELSE 	
		EXECUTE ('UPDATE my_museum.exhibitions SET ' || quote_ident(col_name) || ' = '|| quote_literal(new_val) || ' WHERE exhibition_id = ' || prim_key ||';');
	END IF;
END;
$$ LANGUAGE plpgsql;

--SELECT my_exhibition_data_updater(1, 'exhibition_start_date', '2024-10-10');


/*Ticket creator (transaction table)*/

CREATE OR REPLACE FUNCTION my_museum.ticket_creator (phone_number text, exhibition_n text, ticket_n text)
RETURNS void AS $$
DECLARE 
	cust_id int;
	exh_id int;
BEGIN  
	IF NOT EXISTS (SELECT 1 FROM my_museum.customers WHERE customer_phone_number = phone_number) THEN 
		RAISE NOTICE 'Customer with phone number % not found.', phone_number;
	ELSE 
		SELECT customer_id INTO cust_id FROM my_museum.customers
		WHERE customer_phone_number = phone_number;
		
		IF NOT EXISTS (SELECT 1 FROM my_museum.exhibitions WHERE upper(exhibition_name) = upper(exhibition_n)) THEN 
			RAISE NOTICE 'Exhibition % not found.', exhibition_n;
		ELSE 
			SELECT exhibition_id INTO exh_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = upper(exhibition_n);
			
			IF EXISTS (SELECT 1 FROM my_museum.tickets 
				WHERE exhibition_id = exh_id AND 
					customer_id = cust_id) THEN  
				RAISE NOTICE 'This ticket has already been created.';
			ELSE 
				INSERT INTO my_museum.tickets (ticket_name, exhibition_id, customer_id)
				VALUES (upper(ticket_n), exh_id, cust_id);
			
				RAISE NOTICE 'Ticket has been successfully created.';
			END IF;
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;

--SELECT my_museum.ticket_creator('+599336675', 'okn2024', 'ok123');

/*Creating view of items that were gained during current quarter*/

CREATE OR REPLACE VIEW my_museum.items_gained_current_quarter AS
SELECT i1.arrival_date, i2.item_name , i2.description  FROM my_museum.inventory i1 
LEFT JOIN my_museum.items i2 ON i1.item_id = i2.item_id
WHERE EXTRACT (quarter FROM  i1.arrival_date) = EXTRACT (quarter FROM current_timestamp) AND 
	EXTRACT (YEAR FROM i1.arrival_date) = EXTRACT (YEAR FROM current_date);
