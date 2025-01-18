/*Inserting data into the tables*/

INSERT INTO my_museum.categories (category_name)
SELECT 'ARTWORK'
WHERE NOT EXISTS (
	SELECT category_name FROM my_museum.categories
	WHERE upper(category_name) = 'ARTWORK'
)
UNION 
SELECT 'ARTIFACT'
WHERE NOT EXISTS (
	SELECT category_name FROM my_museum.categories
	WHERE upper(category_name) = 'ARTIFACT'
)
UNION 
SELECT 'SPECIMEN'
WHERE NOT EXISTS (
	SELECT category_name FROM my_museum.categories
	WHERE upper(category_name) = 'SPECIMEN'
)
UNION 
SELECT 'SCULPTURE'
WHERE NOT EXISTS (
	SELECT category_name FROM my_museum.categories
	WHERE upper(category_name) = 'SCULPTURE'
)
UNION 
SELECT 'POTTERY'
WHERE NOT EXISTS (
	SELECT category_name FROM my_museum.categories
	WHERE upper(category_name) = 'POTTERY'
)
UNION 
SELECT 'WEAPON'
WHERE NOT EXISTS (
	SELECT category_name FROM my_museum.categories
	WHERE upper(category_name) = 'WEAPON'
)
RETURNING *;

INSERT INTO my_museum.collections (collection_name)
SELECT 'ANCIENT EGYPT'
WHERE NOT EXISTS (
	SELECT collection_name FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT EGYPT'
)
UNION 
SELECT 'ANCIENT GREECE'
WHERE NOT EXISTS (
	SELECT collection_name FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT GREECE'
)
UNION 
SELECT 'ANCIENT CHINA'
WHERE NOT EXISTS (
	SELECT collection_name FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT CHINA'
)
UNION 
SELECT 'AMERICAN CIVIL WAR'
WHERE NOT EXISTS (
	SELECT collection_name FROM my_museum.collections
	WHERE upper(collection_name) = 'AMERICAN CIVIL WAR'
)
UNION 
SELECT 'RENIASSANCE'
WHERE NOT EXISTS (
	SELECT collection_name FROM my_museum.collections
	WHERE upper(collection_name) = 'RENIASSANCE'
)
UNION 
SELECT 'INDUSTRIAL REVOLUTION'
WHERE NOT EXISTS (
	SELECT collection_name FROM my_museum.collections
	WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION'
)
RETURNING *;

INSERT INTO my_museum.items (item_name, author_name, description, collection_id)
SELECT 'SARCOPHAGUS',
	'UNKNOWN',
	'USED TO BURY LEADERS AND WEALTHY RESIDENTS',
	(
	SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT EGYPT'
	)
WHERE NOT EXISTS (
	SELECT item_name, author_name, description, collection_id FROM my_museum.items
	WHERE upper(item_name) = 'SARCOPHAGUS' AND 
		upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT EGYPT')
)
UNION 
SELECT 'RIFLE OF AN AMERICAN SOLDIER',
	'UNKNOWN',
	'RIFLE WHICH BELONGED TO AN UNKNOWN SOLDIER IN CIVIL WAR',
	(
	SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'AMERICAN CIVIL WAR'
	)
WHERE NOT EXISTS (
	SELECT item_name, author_name, description, collection_id FROM my_museum.items
	WHERE upper(item_name) = 'RIFLE OF AN AMERICAN SOLDIER' AND 
		upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'AMERICAN CIVIL WAR')
)
UNION 
SELECT 'THE LAST SUPPER',
	'LEONARDO DA VINCI',
	'THE PAINTING REPRESENTS THE LAST SUPPER OF CHESUS CHRIST',
	(
	SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'RENIASSANCE'
	)
WHERE NOT EXISTS (
	SELECT item_name, author_name, description, collection_id FROM my_museum.items
	WHERE upper(item_name) = 'THE LAST SUPPER' AND 
		upper(author_name) = 'LEONARDO DA VINCI' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'RENIASSANCE')
)
UNION 
SELECT 'TWO-HANDLED AMPHORA',
	'UNKNOWN',
	'THE PAINTING REPRESENTS THE LAST SUPPER OF CHESUS CHRIST',
	(
	SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT GREECE'
	)
WHERE NOT EXISTS (
	SELECT item_name, author_name, description, collection_id FROM my_museum.items
	WHERE upper(item_name) = 'TWO-HANDLED AMPHORA' AND 
		upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT GREECE')
)
UNION 
SELECT 'TELEGRAPH',
	'SIR WILLIAM FOTHERGILL COOKE',
	'THE FIRST VERSION OF TELEGRAPH CREATED IN ENGLAND',
	(
	SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION'
	)
WHERE NOT EXISTS (
	SELECT item_name, author_name, description, collection_id FROM my_museum.items
	WHERE upper(item_name) = 'TELEGRAPH' AND 
		upper(author_name) = 'SIR WILLIAM FOTHERGILL COOKE' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION')
)
UNION 
SELECT 'FIVE OXEN',
	'HAN HUANG',
	'THE PAINTING WAS LOST DURING THE OCCUPATION OF BEIJING BY THE EIGHT-NATION ALLIANCE IN 1900 AND LATER RECOVERED FROM A COLLECTOR IN HONG KONG DURING THE EARLY 1950S',
	(
	SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT CHINA'
	)
WHERE NOT EXISTS (
	SELECT item_name, author_name, description, collection_id FROM my_museum.items
	WHERE upper(item_name) = 'FIVE OXEN' AND 
		upper(author_name) = 'HAN HUANG' AND  
			collection_id = (SELECT collection_id FROM my_museum.collections
	WHERE upper(collection_name) = 'ANCIENT CHINA')
)
RETURNING *;

INSERT INTO my_museum.categories_items (category_id, item_id)
SELECT 
	(
	SELECT category_id FROM my_museum.categories 
	WHERE upper(category_name) = 'ARTIFACT'
	),
	(
	SELECT item_id FROM my_museum.items 
	WHERE upper(item_name) = 'SARCOPHAGUS' AND 
		upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT EGYPT')
	)
	WHERE NOT EXISTS (
		SELECT category_id , item_id FROM my_museum.categories_items 
		WHERE category_id = (SELECT category_id FROM my_museum.categories 
			WHERE upper(category_name) = 'ARTIFACT') AND 
			item_id = (SELECT item_id FROM my_museum.items 
			WHERE upper(item_name) = 'SARCOPHAGUS' AND 
				upper(author_name) = 'UNKNOWN' AND 
					collection_id = (SELECT collection_id FROM my_museum.collections
					WHERE upper(collection_name) = 'ANCIENT EGYPT'))
	)
UNION 
SELECT 
	(
	SELECT category_id FROM my_museum.categories 
	WHERE upper(category_name) = 'ARTWORK'
	),
	(
	SELECT item_id FROM my_museum.items 
	WHERE upper(item_name) = 'FIVE OXEN' AND 
		upper(author_name) = 'HAN HUANG' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT CHINA')
	)
	WHERE NOT EXISTS (
		SELECT category_id , item_id FROM my_museum.categories_items 
		WHERE category_id = (SELECT category_id FROM my_museum.categories 
			WHERE upper(category_name) = 'ARTWORK') AND 
			item_id = (SELECT item_id FROM my_museum.items 
			WHERE upper(item_name) = 'FIVE OXEN' AND 
				upper(author_name) = 'HAN HUANG' AND 
					collection_id = (SELECT collection_id FROM my_museum.collections
					WHERE upper(collection_name) = 'ANCIENT CHINA'))
	)
UNION 
SELECT 
	(
	SELECT category_id FROM my_museum.categories 
	WHERE upper(category_name) = 'ARTIFACT'
	),
	(
	SELECT item_id FROM my_museum.items 
	WHERE upper(item_name) = 'TELEGRAPH' AND 
		upper(author_name) = 'SIR WILLIAM FOTHERGILL COOKE' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION')
	)
	WHERE NOT EXISTS (
		SELECT category_id , item_id FROM my_museum.categories_items 
		WHERE category_id = (SELECT category_id FROM my_museum.categories 
			WHERE upper(category_name) = 'ARTIFACT') AND 
			item_id = (SELECT item_id FROM my_museum.items 
			WHERE upper(item_name) = 'TELEGRAPH' AND 
				upper(author_name) = 'SIR WILLIAM FOTHERGILL COOKE' AND 
					collection_id = (SELECT collection_id FROM my_museum.collections
					WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION'))
	)
UNION 
SELECT 
	(
	SELECT category_id FROM my_museum.categories 
	WHERE upper(category_name) = 'ARTWORK'
	),
	(
	SELECT item_id FROM my_museum.items 
	WHERE upper(item_name) = 'THE LAST SUPPER' AND 
		upper(author_name) = 'LEONARDO DA VINCI' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'RENIASSANCE')
	)
	WHERE NOT EXISTS (
		SELECT category_id , item_id FROM my_museum.categories_items 
		WHERE category_id = (SELECT category_id FROM my_museum.categories 
			WHERE upper(category_name) = 'ARTWORK') AND 
			item_id = (SELECT item_id FROM my_museum.items 
			WHERE upper(item_name) = 'THE LAST SUPPER' AND 
				upper(author_name) = 'LEONARDO DA VINCI' AND 
					collection_id = (SELECT collection_id FROM my_museum.collections
					WHERE upper(collection_name) = 'RENIASSANCE'))
	)
UNION 
SELECT 
	(
	SELECT category_id FROM my_museum.categories 
	WHERE upper(category_name) = 'WEAPON'
	),
	(
	SELECT item_id FROM my_museum.items 
	WHERE upper(item_name) = 'RIFLE OF AN AMERICAN SOLDIER' AND 
		upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'AMERICAN CIVIL WAR')
	)
	WHERE NOT EXISTS (
		SELECT category_id , item_id FROM my_museum.categories_items 
		WHERE category_id = (SELECT category_id FROM my_museum.categories 
			WHERE upper(category_name) = 'WEAPON') AND 
			item_id = (SELECT item_id FROM my_museum.items 
			WHERE upper(item_name) = 'RIFLE OF AN AMERICAN SOLDIER' AND 
				upper(author_name) = 'UNKNOWN' AND 
					collection_id = (SELECT collection_id FROM my_museum.collections
					WHERE upper(collection_name) = 'AMERICAN CIVIL WAR'))
	)
UNION 
SELECT 
	(
	SELECT category_id FROM my_museum.categories 
	WHERE upper(category_name) = 'POTTERY'
	),
	(
	SELECT item_id FROM my_museum.items 
	WHERE upper(item_name) = 'TWO-HANDLED AMPHORA' AND 
		upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT GREECE')
	)
	WHERE NOT EXISTS (
		SELECT category_id , item_id FROM my_museum.categories_items 
		WHERE category_id = (SELECT category_id FROM my_museum.categories 
			WHERE upper(category_name) = 'POTTERY') AND 
			item_id = (SELECT item_id FROM my_museum.items 
			WHERE upper(item_name) = 'TWO-HANDLED AMPHORA' AND 
				upper(author_name) = 'UNKNOWN' AND 
					collection_id = (SELECT collection_id FROM my_museum.collections
					WHERE upper(collection_name) = 'ANCIENT GREECE'))
	)
RETURNING *;

INSERT INTO my_museum.warehouses (warehouse_address)
SELECT 'MYSQL AVENUE 1'
WHERE NOT EXISTS (SELECT 1 FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 1')
UNION 
SELECT 'MYSQL AVENUE 2'
WHERE NOT EXISTS (SELECT 1 FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 2')
UNION 
SELECT 'MYSQL AVENUE 3'
WHERE NOT EXISTS (SELECT 1 FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 3')
UNION 
SELECT 'MYSQL AVENUE 4'
WHERE NOT EXISTS (SELECT 1 FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 4')
UNION 
SELECT 'MYSQL AVENUE 5'
WHERE NOT EXISTS (SELECT 1 FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 5')
UNION 
SELECT 'MYSQL AVENUE 6'
WHERE NOT EXISTS (SELECT 1 FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 6')
RETURNING *;

INSERT INTO my_museum.inventory (item_id, warehouse_id, arrival_date)
SELECT (
	SELECT item_id FROM my_museum.items
	WHERE upper(item_name) = 'THE LAST SUPPER' AND 
		upper(author_name) = 'LEONARDO DA VINCI' AND 
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'RENIASSANCE')
	),
	(
	SELECT warehouse_id FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 1'
	),
	'2024-06-01'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.inventory 
	WHERE item_id = (SELECT item_id FROM my_museum.items
		WHERE upper(item_name) = 'THE LAST SUPPER' AND 
			upper(author_name) = 'LEONARDO DA VINCI' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
				WHERE upper(collection_name) = 'RENIASSANCE')) AND 
		warehouse_id  = (SELECT warehouse_id FROM my_museum.warehouses 
			WHERE upper(warehouse_address) = 'MYSQL AVENUE 1') AND 
		arrival_date = '2024-06-01'::timestamptz
	)
UNION 
SELECT (
	SELECT item_id FROM my_museum.items
	WHERE upper(item_name) = 'SARCOPHAGUS' AND 
		upper(author_name) = 'UNKNOWN' AND 
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT EGYPT')
	),
	(
	SELECT warehouse_id FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 2'
	),
	'2024-05-15'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.inventory 
	WHERE item_id = (SELECT item_id FROM my_museum.items
		WHERE upper(item_name) = 'SARCOPHAGUS' AND 
			upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
				WHERE upper(collection_name) = 'ANCIENT EGYPT')) AND 
		warehouse_id  = (SELECT warehouse_id FROM my_museum.warehouses 
			WHERE upper(warehouse_address) = 'MYSQL AVENUE 2') AND 
		arrival_date = '2024-05-15'::timestamptz
	)
UNION 
SELECT (
	SELECT item_id FROM my_museum.items
	WHERE upper(item_name) = 'RIFLE OF AN AMERICAN SOLDIER' AND 
		upper(author_name) = 'UNKNOWN' AND 
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'AMERICAN CIVIL WAR')
	),
	(
	SELECT warehouse_id FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 3'
	),
	'2024-04-20'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.inventory 
	WHERE item_id = (SELECT item_id FROM my_museum.items
		WHERE upper(item_name) = 'RIFLE OF AN AMERICAN SOLDIER' AND 
			upper(author_name) = 'UNKNOWN' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
				WHERE upper(collection_name) = 'AMERICAN CIVIL WAR')) AND 
		warehouse_id  = (SELECT warehouse_id FROM my_museum.warehouses 
			WHERE upper(warehouse_address) = 'MYSQL AVENUE 3') AND 
		arrival_date = '2024-04-20'::timestamptz
	)
UNION 
SELECT (
	SELECT item_id FROM my_museum.items
	WHERE upper(item_name) = 'TWO-HANDLED AMPHORA' AND 
		upper(author_name) = 'UNKNOWN' AND 
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT GREECE')
	),
	(
	SELECT warehouse_id FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 2'
	),
	'2024-04-13'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.inventory 
	WHERE item_id = (SELECT item_id FROM my_museum.items
		WHERE upper(item_name) = 'TWO-HANDLED AMPHORA' AND 
		upper(author_name) = 'UNKNOWN' AND 
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT GREECE')) AND 
		warehouse_id  = (SELECT warehouse_id FROM my_museum.warehouses 
			WHERE upper(warehouse_address) = 'MYSQL AVENUE 2') AND 
		arrival_date = '2024-04-13'::timestamptz
	)
UNION 
SELECT (
	SELECT item_id FROM my_museum.items
	WHERE upper(item_name) = 'FIVE OXEN' AND 
		upper(author_name) = 'HAN HUANG' AND  
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'ANCIENT CHINA')
	),
	(
	SELECT warehouse_id FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 3'
	),
	'2024-05-28'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.inventory 
	WHERE item_id = (SELECT item_id FROM my_museum.items
		WHERE upper(item_name) = 'FIVE OXEN' AND 
			upper(author_name) = 'HAN HUANG' AND  
			collection_id = (SELECT collection_id FROM my_museum.collections
				WHERE upper(collection_name) = 'ANCIENT CHINA')) AND 
		warehouse_id  = (SELECT warehouse_id FROM my_museum.warehouses 
			WHERE upper(warehouse_address) = 'MYSQL AVENUE 3') AND 
		arrival_date = '2024-05-28'::timestamptz
	)
UNION 
SELECT (
	SELECT item_id FROM my_museum.items
	WHERE upper(item_name) = 'TELEGRAPH' AND 
		upper(author_name) = 'SIR WILLIAM FOTHERGILL COOKE' AND 
		collection_id = (SELECT collection_id FROM my_museum.collections
			WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION')
	),
	(
	SELECT warehouse_id FROM my_museum.warehouses 
	WHERE upper(warehouse_address) = 'MYSQL AVENUE 2'
	),
	'2024-06-10'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.inventory 
	WHERE item_id = (SELECT item_id FROM my_museum.items
		WHERE upper(item_name) = 'TELEGRAPH' AND 
			upper(author_name) = 'SIR WILLIAM FOTHERGILL COOKE' AND 
			collection_id = (SELECT collection_id FROM my_museum.collections
				WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION')) AND 
		warehouse_id  = (SELECT warehouse_id FROM my_museum.warehouses 
			WHERE upper(warehouse_address) = 'MYSQL AVENUE 2') AND 
		arrival_date = '2024-06-10'::timestamptz
	)
RETURNING *;

INSERT INTO my_museum.exhibitions (exhibition_name, exhibition_start_date, exhibition_end_date)
SELECT 'EMU2024',
	'2024-10-10 18:00:00'::timestamptz,
	'2024-10-20 18:00:00'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'EMU2024' AND 
		exhibition_start_date = '2024-10-10 18:00:00'::timestamptz AND 
		exhibition_end_date = '2024-10-20 18:00:00'::timestamptz
)
UNION 
SELECT 'ORA2024',
	'2024-11-01 18:00:00'::timestamptz,
	'2024-11-05 23:00:00'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'ORA2024' AND 
		exhibition_start_date = '2024-11-01 18:00:00'::timestamptz AND 
		exhibition_end_date = '2024-11-05 23:00:00'::timestamptz
)
UNION 
SELECT 'OKN2024',
	'2024-07-01 18:00:00'::timestamptz,
	'2024-07-10 23:00:00'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'OKN2024' AND 
		exhibition_start_date = '2024-07-01 18:00:00'::timestamptz AND 
		exhibition_end_date = '2024-07-10 23:00:00'::timestamptz
)
UNION 
SELECT 'APA2024',
	'2024-08-01 18:00:00'::timestamptz,
	'2024-08-20 23:00:00'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'APA2024' AND 
		exhibition_start_date = '2024-08-01 18:00:00'::timestamptz AND 
		exhibition_end_date = '2024-08-20 23:00:00'::timestamptz
)
UNION 
SELECT 'PLO2024',
	'2024-09-15 18:00:00'::timestamptz,
	'2024-09-20 23:00:00'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'PLO2024' AND 
		exhibition_start_date = '2024-09-15 18:00:00'::timestamptz AND 
		exhibition_end_date = '2024-09-20 23:00:00'::timestamptz
)
UNION 
SELECT 'GOI2024',
	'2024-12-20 18:00:00'::timestamptz,
	'2024-12-23 23:00:00'::timestamptz
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'GOI2024' AND 
		exhibition_start_date = '2024-12-20 18:00:00'::timestamptz AND 
		exhibition_end_date = '2024-12-23 23:00:00'::timestamptz
)
RETURNING *;

INSERT INTO my_museum.collections_exhibitions (collection_id, exhibition_id)
SELECT (
	SELECT collection_id FROM my_museum.collections 
	WHERE upper(collection_name) = 'RENIASSANCE'
	),
	(
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'EMU2024'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.collections_exhibitions 
	WHERE collection_id = (SELECT collection_id FROM my_museum.collections 
			WHERE upper(collection_name) = 'RENIASSANCE') AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'EMU2024')
	)
UNION 
SELECT (
	SELECT collection_id FROM my_museum.collections 
	WHERE upper(collection_name) = 'AMERICAN CIVIL WAR'
	),
	(
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'ORA2024'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.collections_exhibitions 
	WHERE collection_id = (SELECT collection_id FROM my_museum.collections 
			WHERE upper(collection_name) = 'AMERICAN CIVIL WAR') AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'ORA2024')
	)
UNION 
SELECT (
	SELECT collection_id FROM my_museum.collections 
	WHERE upper(collection_name) = 'ANCIENT GREECE'
	),
	(
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'OKN2024'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.collections_exhibitions 
	WHERE collection_id = (SELECT collection_id FROM my_museum.collections 
			WHERE upper(collection_name) = 'ANCIENT GREECE') AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'OKN2024')
	)
UNION 
SELECT (
	SELECT collection_id FROM my_museum.collections 
	WHERE upper(collection_name) = 'ANCIENT EGYPT'
	),
	(
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'APA2024'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.collections_exhibitions 
	WHERE collection_id = (SELECT collection_id FROM my_museum.collections 
			WHERE upper(collection_name) = 'ANCIENT EGYPT') AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'APA2024')
	)
UNION 
SELECT (
	SELECT collection_id FROM my_museum.collections 
	WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION'
	),
	(
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'PLO2024'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.collections_exhibitions 
	WHERE collection_id = (SELECT collection_id FROM my_museum.collections 
			WHERE upper(collection_name) = 'INDUSTRIAL REVOLUTION') AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'PLO2024')
	)
UNION 
SELECT (
	SELECT collection_id FROM my_museum.collections 
	WHERE upper(collection_name) = 'ANCIENT CHINA'
	),
	(
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'GOI2024'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.collections_exhibitions 
	WHERE collection_id = (SELECT collection_id FROM my_museum.collections 
			WHERE upper(collection_name) = 'ANCIENT CHINA') AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'GOI2024')
	)
RETURNING *;

INSERT INTO my_museum.customers (customer_name, customer_phone_number)
SELECT 'JAMES DOE',
	'+599113344'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.customers
	WHERE upper(customer_name) = 'JAMES DOE' AND 
		customer_phone_number = '+599113344'
)
UNION 
SELECT 'JACK SWANSON',
	'+599336675'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.customers
	WHERE upper(customer_name) = 'JACK SWANSON' AND 
		customer_phone_number = '+599336675'
)
UNION 
SELECT 'AMY JACKSON',
	'+599781237'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.customers
	WHERE upper(customer_name) = 'AMY JACKSON' AND 
		customer_phone_number = '+599781237'
)
UNION 
SELECT 'CHRIS MARKOS',
	'+599001412'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.customers
	WHERE upper(customer_name) = 'CHRIS MARKOS' AND 
		customer_phone_number = '+599001412'
)
UNION 
SELECT 'MATT RUST',
	'+599851915'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.customers
	WHERE upper(customer_name) = 'MATT RUST' AND 
		customer_phone_number = '+599851915'
)
UNION 
SELECT 'FOREST GRUMP',
	'+599111111'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.customers
	WHERE upper(customer_name) = 'FOREST GRUMP' AND 
		customer_phone_number = '+599111111'
)
RETURNING *;

INSERT INTO my_museum.tickets (ticket_name, exhibition_id, customer_id)
SELECT 'HU9I81',
	(
	SELECT exhibition_id FROM my_museum.exhibitions
	WHERE upper(exhibition_name) = 'EMU2024'
	),
	(
	SELECT customer_id FROM my_museum.customers 
	WHERE customer_phone_number = '+599113344'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.tickets 
	WHERE upper(ticket_name) = 'HU9I81' AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = 'EMU2024') AND 
		customer_id = (SELECT customer_id FROM my_museum.customers 
			WHERE customer_phone_number = '+599113344')
)
UNION 
SELECT 'YQ9U1U',
	(
	SELECT exhibition_id FROM my_museum.exhibitions
	WHERE upper(exhibition_name) = 'EMU2024'
	),
	(
	SELECT customer_id FROM my_museum.customers 
	WHERE customer_phone_number = '+599336675'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.tickets 
	WHERE upper(ticket_name) = 'YQ9U1U' AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = 'EMU2024') AND 
		customer_id = (SELECT customer_id FROM my_museum.customers 
			WHERE customer_phone_number = '+599336675')
)
UNION 
SELECT 'U009I1',
	(
	SELECT exhibition_id FROM my_museum.exhibitions
	WHERE upper(exhibition_name) = 'OKN2024'
	),
	(
	SELECT customer_id FROM my_museum.customers 
	WHERE customer_phone_number = '+599851915'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.tickets 
	WHERE upper(ticket_name) = 'U009I1' AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = 'OKN2024') AND 
		customer_id = (SELECT customer_id FROM my_museum.customers 
			WHERE customer_phone_number = '+599851915')
)
UNION 
SELECT 'K12P01',
	(
	SELECT exhibition_id FROM my_museum.exhibitions
	WHERE upper(exhibition_name) = 'OKN2024'
	),
	(
	SELECT customer_id FROM my_museum.customers 
	WHERE customer_phone_number = '+599001412'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.tickets 
	WHERE upper(ticket_name) = 'K12P01' AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = 'OKN2024') AND 
		customer_id = (SELECT customer_id FROM my_museum.customers 
			WHERE customer_phone_number = '+599001412')
)
UNION 
SELECT 'AI01UP',
	(
	SELECT exhibition_id FROM my_museum.exhibitions
	WHERE upper(exhibition_name) = 'GOI2024'
	),
	(
	SELECT customer_id FROM my_museum.customers 
	WHERE customer_phone_number = '+599781237'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.tickets 
	WHERE upper(ticket_name) = 'AI01UP' AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = 'GOI2024') AND 
		customer_id = (SELECT customer_id FROM my_museum.customers 
			WHERE customer_phone_number = '+599781237')
)
UNION 
SELECT 'IO12T5',
	(
	SELECT exhibition_id FROM my_museum.exhibitions
	WHERE upper(exhibition_name) = 'PLO2024'
	),
	(
	SELECT customer_id FROM my_museum.customers 
	WHERE customer_phone_number = '+599111111'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.tickets 
	WHERE upper(ticket_name) = 'IO12T5' AND 
		exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions
			WHERE upper(exhibition_name) = 'PLO2024') AND 
		customer_id = (SELECT customer_id FROM my_museum.customers 
			WHERE customer_phone_number = '+599111111')
)
RETURNING *;

INSERT INTO my_museum.halls (hall_name, hall_slots)
SELECT 'ENGLISH HALL',
	31
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls 
	WHERE upper(hall_name) = 'ENGLISH HALL'
)
UNION 
SELECT 'BAROQUE HALL',
	26
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls 
	WHERE upper(hall_name) = 'BAROQUE HALL'
)
UNION 
SELECT 'SMALL HALL',
	5
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls 
	WHERE upper(hall_name) = 'SMALL HALL'
)
UNION 
SELECT 'BALL HALL',
	131
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls 
	WHERE upper(hall_name) = 'BALL HALL'
)
UNION 
SELECT 'CHINESE HALL',
	21
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls 
	WHERE upper(hall_name) = 'CHINESE HALL'
)
UNION 
SELECT 'ITALIAN HALL',
	41
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls 
	WHERE upper(hall_name) = 'ITALIAN HALL'
)
RETURNING *;

INSERT INTO my_museum.exhibitions_halls (exhibition_id, hall_id)
SELECT (
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'EMU2024'
	),
	(
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'ENGLISH HALL'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions_halls 
	WHERE exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'EMU2024') AND 
		hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'ENGLISH HALL')
)
UNION 
SELECT (
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'ORA2024'
	),
	(
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'CHINESE HALL'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions_halls 
	WHERE exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'ORA2024') AND 
		hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'CHINESE HALL')
)
UNION 
SELECT (
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'OKN2024'
	),
	(
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'SMALL HALL'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions_halls 
	WHERE exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'OKN2024') AND 
		hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'SMALL HALL')
)
UNION 
SELECT (
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'APA2024'
	),
	(
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'ITALIAN HALL'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions_halls 
	WHERE exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'APA2024') AND 
		hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'ITALIAN HALL')
)
UNION 
SELECT (
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'PLO2024'
	),
	(
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'BAROQUE HALL'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions_halls 
	WHERE exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'PLO2024') AND 
		hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'BAROQUE HALL')
)
UNION 
SELECT (
	SELECT exhibition_id FROM my_museum.exhibitions 
	WHERE upper(exhibition_name) = 'GOI2024'
	),
	(
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'SMALL HALL'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.exhibitions_halls 
	WHERE exhibition_id = (SELECT exhibition_id FROM my_museum.exhibitions 
			WHERE upper(exhibition_name) = 'GOI2024') AND 
		hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'SMALL HALL')
)
RETURNING *;

INSERT INTO my_museum.employees (employee_name, badge_name)
SELECT 'KEVIN NORM',
	'0012'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.employees 
	WHERE badge_name = '0012'
)
UNION 
SELECT 'ROGER BLAKE',
	'0013'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.employees 
	WHERE badge_name = '0013'
)
UNION 
SELECT 'STEVEN EDGAR',
	'0014'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.employees 
	WHERE badge_name = '0014'
)
UNION 
SELECT 'KEN BARRY',
	'0015'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.employees 
	WHERE badge_name = '0015'
)
UNION 
SELECT 'ERAR INNINGTON',
	'0016'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.employees 
	WHERE badge_name = '0016'
)
UNION 
SELECT 'PATRICE MONBLANCE',
	'0017'
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.employees 
	WHERE badge_name = '0017'
)
RETURNING *;

INSERT INTO my_museum.halls_employees (hall_id, employee_id)
SELECT (
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'BAROQUE HALL' 
	),
	(
	SELECT employee_id FROM my_museum.employees 
	WHERE badge_name = '0012'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls_employees 
	WHERE hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'BAROQUE HALL') AND 
		employee_id = (SELECT employee_id FROM my_museum.employees 
			WHERE badge_name = '0012')
)
UNION 
SELECT (
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'CHINESE HALL' 
	),
	(
	SELECT employee_id FROM my_museum.employees 
	WHERE badge_name = '0013'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls_employees 
	WHERE hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'CHINESE HALL') AND 
		employee_id = (SELECT employee_id FROM my_museum.employees 
			WHERE badge_name = '0013')
)
UNION 
SELECT (
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'BALL HALL' 
	),
	(
	SELECT employee_id FROM my_museum.employees 
	WHERE badge_name = '0014'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls_employees 
	WHERE hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'BALL HALL') AND 
		employee_id = (SELECT employee_id FROM my_museum.employees 
			WHERE badge_name = '0014')
)
UNION 
SELECT (
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'ENGLISH HALL' 
	),
	(
	SELECT employee_id FROM my_museum.employees 
	WHERE badge_name = '0015'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls_employees 
	WHERE hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'ENGLISH HALL') AND 
		employee_id = (SELECT employee_id FROM my_museum.employees 
			WHERE badge_name = '0015')
)
UNION 
SELECT (
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'ITALIAN HALL' 
	),
	(
	SELECT employee_id FROM my_museum.employees 
	WHERE badge_name = '0016'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls_employees 
	WHERE hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'ITALIAN HALL') AND 
		employee_id = (SELECT employee_id FROM my_museum.employees 
			WHERE badge_name = '0016')
)
UNION 
SELECT (
	SELECT hall_id FROM my_museum.halls 
	WHERE upper(hall_name) = 'SMALL HALL' 
	),
	(
	SELECT employee_id FROM my_museum.employees 
	WHERE badge_name = '0017'
	)
WHERE NOT EXISTS (
	SELECT 1 FROM my_museum.halls_employees 
	WHERE hall_id = (SELECT hall_id FROM my_museum.halls 
			WHERE upper(hall_name) = 'SMALL HALL') AND 
		employee_id = (SELECT employee_id FROM my_museum.employees 
			WHERE badge_name = '0017')
)
RETURNING *;
