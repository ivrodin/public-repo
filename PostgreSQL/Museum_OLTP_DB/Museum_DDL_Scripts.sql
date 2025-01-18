/*Connect to the 'cultural_facilities' database an execute following script:*/

CREATE SCHEMA IF NOT EXISTS my_museum;

/*Creating tables according to the database schema*/

CREATE TABLE IF NOT EXISTS my_museum.categories (
	category_id serial,
	category_name varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.categories_items (
	category_id int NOT NULL,
	item_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.items (
	item_id serial,
	item_name varchar(50) NOT NULL,
	author_name varchar(50) DEFAULT 'UNKNOWN',
	description TEXT NOT NULL,
	collection_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.inventory (
	inventory_id serial,
	item_id int NOT NULL,
	warehouse_id int NOT NULL,
	arrival_date timestamptz DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS my_museum.warehouses (
	warehouse_id serial,
	warehouse_address varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.collections (
	collection_id serial,
	collection_name varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.collections_exhibitions (
	collection_id int NOT NULL,
	exhibition_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.exhibitions (
	exhibition_id serial,
	exhibition_name varchar(50) NOT NULL,
	exhibition_start_date timestamptz NOT NULL,
	exhibition_end_date timestamptz NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.tickets (
	ticket_id serial,
	ticket_name varchar(20) NOT NULL,
	exhibition_id int NOT NULL,
	customer_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.customers (
	customer_id serial,
	customer_name varchar(50) NOT NULL,
	customer_phone_number varchar(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.exhibitions_halls (
	exhibition_id int NOT NULL,
	hall_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.halls (
	hall_id serial,
	hall_name varchar(50) NOT NULL,
	hall_slots int NOT NULL 
);

CREATE TABLE IF NOT EXISTS my_museum.halls_employees (
	hall_id int NOT NULL,
	employee_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_museum.employees (
	employee_id serial,
	employee_name varchar(50) NOT NULL,
	badge_name varchar(20) NOT NULL
);

/* Adding primary key constraints, while checking if these primary key constraints exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'categories_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.categories 
        ADD CONSTRAINT categories_pk PRIMARY KEY (category_id);
    END IF;

   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'categories_items_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.categories_items 
        ADD CONSTRAINT categories_items_pk PRIMARY KEY (category_id, item_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'items_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.items 
        ADD CONSTRAINT items_pk PRIMARY KEY (item_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'inventory_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.inventory 
        ADD CONSTRAINT inventory_pk PRIMARY KEY (inventory_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'warehouses_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.warehouses 
        ADD CONSTRAINT warehouses_pk PRIMARY KEY (warehouse_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'collections_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.collections 
        ADD CONSTRAINT collections_pk PRIMARY KEY (collection_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'collections_exhibitions_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.collections_exhibitions 
        ADD CONSTRAINT collections_exhibitions_pk PRIMARY KEY (collection_id, exhibition_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions 
        ADD CONSTRAINT exhibitions_pk PRIMARY KEY (exhibition_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.tickets  
        ADD CONSTRAINT tickets_pk PRIMARY KEY (ticket_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customers_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.customers 
        ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_halls_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions_halls 
        ADD CONSTRAINT exhibitions_halls_pk PRIMARY KEY (exhibition_id, hall_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'halls_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.halls 
        ADD CONSTRAINT halls_pk PRIMARY KEY (hall_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'halls_employees_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.halls_employees 
        ADD CONSTRAINT halls_employees_pk PRIMARY KEY (hall_id, employee_id);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employees_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.employees 
        ADD CONSTRAINT employees_pk PRIMARY KEY (employee_id);
    END IF;
END $$;

/* Adding foreign key constraints, while checking if these foreign key constraints exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'categories_items_category_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.categories_items 
        ADD CONSTRAINT categories_items_category_fk FOREIGN KEY (category_id) REFERENCES my_museum.categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'categories_items_item_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.categories_items 
        ADD CONSTRAINT categories_items_item_fk FOREIGN KEY (item_id) REFERENCES my_museum.items(item_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'items_collection_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.items 
        ADD CONSTRAINT items_collection_fk FOREIGN KEY (collection_id) REFERENCES my_museum.collections(collection_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'inventory_item_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.inventory 
        ADD CONSTRAINT inventory_item_fk FOREIGN KEY (item_id) REFERENCES my_museum.items(item_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'inventory_warehouse_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.inventory 
        ADD CONSTRAINT inventory_warehouse_fk FOREIGN KEY (warehouse_id) REFERENCES my_museum.warehouses(warehouse_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'collections_exhibitions_collection_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.collections_exhibitions 
        ADD CONSTRAINT collections_exhibitions_collection_fk FOREIGN KEY (collection_id) REFERENCES my_museum.collections(collection_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'collections_exhibitions_exhibition_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.collections_exhibitions 
        ADD CONSTRAINT collections_exhibitions_exhibition_fk FOREIGN KEY (exhibition_id) REFERENCES my_museum.exhibitions(exhibition_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_exhibition_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.tickets 
        ADD CONSTRAINT tickets_exhibition_fk FOREIGN KEY (exhibition_id) REFERENCES my_museum.exhibitions(exhibition_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_customer_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.tickets 
        ADD CONSTRAINT tickets_customer_fk FOREIGN KEY (customer_id) REFERENCES my_museum.customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_halls_exhibition_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions_halls 
        ADD CONSTRAINT exhibitions_halls_exhibition_fk FOREIGN KEY (exhibition_id) REFERENCES my_museum.exhibitions(exhibition_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_halls_hall_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions_halls 
        ADD CONSTRAINT exhibitions_halls_hall_fk FOREIGN KEY (hall_id) REFERENCES my_museum.halls(hall_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'halls_employees_hall_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.halls_employees  
        ADD CONSTRAINT halls_employees_hall_fk FOREIGN KEY (hall_id) REFERENCES my_museum.halls(hall_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'halls_employees_employee_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.halls_employees  
        ADD CONSTRAINT halls_employees_employee_fk FOREIGN KEY (employee_id) REFERENCES my_museum.employees(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
END $$;

/* Adding CHECK constraint, while checking if this CHECK constraint exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'inventory_arrival_date_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.inventory 
        ADD CONSTRAINT inventory_arrival_date_check CHECK (arrival_date > '2024-01-01'::timestamptz);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_exhibition_start_date_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions 
        ADD CONSTRAINT exhibitions_exhibition_start_date_check CHECK (exhibition_start_date > '2024-01-01'::timestamptz);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_exhibition_end_date_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions 
        ADD CONSTRAINT exhibitions_exhibition_end_date_check CHECK (exhibition_end_date > '2024-01-01'::timestamptz);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibitions_exhibition_start_vs_end_date_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions 
        ADD CONSTRAINT exhibitions_exhibition_start_vs_end_date_check CHECK (exhibition_end_date > exhibition_start_date);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'halls_hall_slots_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.halls 
        ADD CONSTRAINT halls_hall_slots_check CHECK (hall_slots > 0);
    END IF;
END $$;

/* Adding UNIQUE constraint, while checking if this UNIQUE constraint exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'category_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.categories 
        ADD CONSTRAINT category_name_unique UNIQUE (category_name);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'warehouse_address_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.warehouses  
        ADD CONSTRAINT warehouse_address_unique UNIQUE (warehouse_address);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'collection_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.collections  
        ADD CONSTRAINT collection_name_unique UNIQUE (collection_name);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'exhibition_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.exhibitions  
        ADD CONSTRAINT exhibition_name_unique UNIQUE (exhibition_name);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ticket_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.tickets  
        ADD CONSTRAINT ticket_name_unique UNIQUE (ticket_name);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customer_phone_number_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.customers  
        ADD CONSTRAINT customer_phone_number_unique UNIQUE (customer_phone_number);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'hall_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.halls 
        ADD CONSTRAINT hall_name_unique UNIQUE (hall_name);
    END IF;
   
   IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employee_badge_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_museum'
        )
    ) THEN
        ALTER TABLE my_museum.employees 
        ADD CONSTRAINT employee_badge_name_unique UNIQUE (badge_name);
    END IF;
END $$;
