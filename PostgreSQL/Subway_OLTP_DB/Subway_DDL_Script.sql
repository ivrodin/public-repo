/*Connect to the 'subway' database and execute following script:*/

CREATE SCHEMA IF NOT EXISTS my_subway;

/*Creating custom datatypes*/

DO $$
BEGIN 
	IF NOT EXISTS (
		SELECT * FROM pg_catalog.pg_type
		WHERE typname = 'route_type'
	) THEN 
	/* Creating custom datatype for types of routes */
		CREATE TYPE route_type
			AS ENUM ('TECHNICAL', 'SERVICE', 'TRANSPORT');
	END IF;
	IF NOT EXISTS (
		SELECT * FROM pg_catalog.pg_type
		WHERE typname = 'ticket_type'
	) THEN 
	/* Creating custom datatype for types of tickets */
		CREATE TYPE ticket_type
			AS ENUM ('LIMITED 20', 'LIMITED 60', 'LIMITED 100', 'UNLIMITED');
	END IF;
END $$;

/*Creating tables according to the database schema*/

CREATE TABLE IF NOT EXISTS my_subway.trains (
	train_id serial,
	train_name varchar(50) NOT NULL,
	req_number_of_employees int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.lines (
	line_id serial,
	line_name varchar(50) NOT NULL,
	line_open_time time NOT NULL,
	line_close_time time NOT NULL,
	req_number_of_employees int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.routes (
	route_id serial,
	route_name varchar(50) NOT NULL,
	type_of_route route_type NOT NULL,
	req_number_of_employees int NOT NULL,
	line_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.stations (
	station_id serial,
	station_name varchar(50) NOT NULL,
	req_number_of_employees int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.employees (
	employee_id serial,
	employee_name varchar(50) NOT NULL,
	employee_role varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.maintances (
	maintance_id serial,
	last_maintance_date date NOT NULL,
	estimated_maintance_date date NOT NULL										
);

CREATE TABLE IF NOT EXISTS my_subway.tunnels (
	tunnel_id serial,
	tunnel_name varchar(50) NOT NULL,
	line_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.tracks (
	track_id serial,
	track_name varchar(50) NOT NULL,
	tunnel_id int NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.shifts (
	shift_id serial,
	shift_startTime timestamp WITH time ZONE NOT NULL,
	shift_endTime timestamp WITH time ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.customers (
	customer_id serial,
	customer_name varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.tickets (
	ticket_id serial,
	type_of_ticket ticket_type NOT NULL,
	ticket_price decimal(6,2) NOT NULL,
	ticket_discount decimal(3,2) DEFAULT 0,
	ticket_startDate timestamp WITH time ZONE NOT NULL,
	ticket_expireDate timestamp WITH time ZONE NOT NULL,
	customer_id int NOT NULL	
);

CREATE TABLE IF NOT EXISTS my_subway.trains_arrivals_departures (
	arrival_departure_id serial,
	train_id int NOT NULL,
	station_id int NOT NULL,
	arrival_time timestamp WITH time ZONE NOT NULL,
	departure_time timestamp WITH time ZONE NOT NULL	
);

CREATE TABLE IF NOT EXISTS my_subway.tickets_stations (
	ticket_id int,
	station_id int,
	time_of_use timestamp WITH time ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS my_subway.routes_stations (
	route_id int,
	station_id int
);

CREATE TABLE IF NOT EXISTS my_subway.stations_employees (
	station_id int,
	employee_id int
);

CREATE TABLE IF NOT EXISTS my_subway.stations_lines (
	station_id int,
	line_id int
);

CREATE TABLE IF NOT EXISTS my_subway.lines_trains (
	line_id int,
	train_id int
);

CREATE TABLE IF NOT EXISTS my_subway.routes_trains (
	route_id int,
	train_id int
);

CREATE TABLE IF NOT EXISTS my_subway.trains_employees (
	train_id int,
	employee_id int
);

CREATE TABLE IF NOT EXISTS my_subway.employees_shifts (
	employee_id int,
	shift_id int
);

CREATE TABLE IF NOT EXISTS my_subway.trains_maintances (
	train_id int,
	maintance_id int
);

CREATE TABLE IF NOT EXISTS my_subway.routes_maintances (
	route_id int,
	maintance_id int
);

CREATE TABLE IF NOT EXISTS my_subway.tracks_maintances (
	track_id int,
	maintance_id int
);

CREATE TABLE IF NOT EXISTS my_subway.tunnels_maintances (
	tunnel_id int,
	maintance_id int
);

CREATE TABLE IF NOT EXISTS my_subway.lines_maintances (
	line_id int,
	maintance_id int
);

CREATE TABLE IF NOT EXISTS my_subway.stations_maintances (
	station_id int,
	maintance_id int
);


/* Adding primary key constraints, while checking if these primary key constraints exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains
        ADD CONSTRAINT train_pk PRIMARY KEY (train_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines 
        ADD CONSTRAINT lines_pk PRIMARY KEY (line_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes 
        ADD CONSTRAINT routes_pk PRIMARY KEY (route_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations 
        ADD CONSTRAINT stations_pk PRIMARY KEY (station_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employees_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.employees 
        ADD CONSTRAINT employees_pk PRIMARY KEY (employee_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.maintances 
        ADD CONSTRAINT maintances_pk PRIMARY KEY (maintance_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tunnels_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tunnels
        ADD CONSTRAINT tunnels_pk PRIMARY KEY (tunnel_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tracks_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks
        ADD CONSTRAINT tracks_pk PRIMARY KEY (track_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'shifts_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.shifts
        ADD CONSTRAINT shifts_pk PRIMARY KEY (shift_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'customers_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.customers
        ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets
        ADD CONSTRAINT tickets_pk PRIMARY KEY (ticket_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_arrivals_departures_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_arrivals_departures
        ADD CONSTRAINT trains_arrivals_departures_pk PRIMARY KEY (arrival_departure_id);
    END IF;
   
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_stations_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets_stations
        ADD CONSTRAINT tickets_stations_pk PRIMARY KEY (station_id, ticket_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_stations_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_stations
        ADD CONSTRAINT routes_stations_pk PRIMARY KEY (station_id, route_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_stations_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_stations
        ADD CONSTRAINT routes_stations_pk PRIMARY KEY (station_id, route_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_employees_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_employees
        ADD CONSTRAINT stations_employees_pk PRIMARY KEY (station_id, employee_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_lines_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_lines
        ADD CONSTRAINT stations_lines_pk PRIMARY KEY (station_id, line_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_trains_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines_trains
        ADD CONSTRAINT lines_trains_pk PRIMARY KEY (train_id, line_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_trains_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_trains
        ADD CONSTRAINT routes_trains_pk PRIMARY KEY (train_id, route_id);
    END IF;   
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_employees_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_employees
        ADD CONSTRAINT trains_employees_pk PRIMARY KEY (train_id, employee_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employees_shifts_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.employees_shifts
        ADD CONSTRAINT employees_shifts_pk PRIMARY KEY (shift_id, employee_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_maintances
        ADD CONSTRAINT trains_maintances_pk PRIMARY KEY (train_id, maintance_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_maintances
        ADD CONSTRAINT routes_maintances_pk PRIMARY KEY (route_id, maintance_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tracks_maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks_maintances
        ADD CONSTRAINT tracks_maintances_pk PRIMARY KEY (track_id, maintance_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tunnels_maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tunnels_maintances
        ADD CONSTRAINT tunnels_maintances_pk PRIMARY KEY (tunnel_id, maintance_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines_maintances
        ADD CONSTRAINT lines_maintances_pk PRIMARY KEY (line_id, maintance_id);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_maintances_pk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_maintances
        ADD CONSTRAINT stations_maintances_pk PRIMARY KEY (station_id, maintance_id);
    END IF;
END $$;

/* Adding foreign key constraints, while checking if these foreign key constraints exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'route_line_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes
        ADD CONSTRAINT route_line_fk FOREIGN KEY (line_id) REFERENCES my_subway.lines(line_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tunnel_line_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tunnels
        ADD CONSTRAINT tunnel_line_fk FOREIGN KEY (line_id) REFERENCES my_subway.lines(line_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'track_tunnel_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks
        ADD CONSTRAINT track_tunnel_fk FOREIGN KEY (tunnel_id) REFERENCES my_subway.tunnels(tunnel_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ticket_customer_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets
        ADD CONSTRAINT ticket_customer_fk FOREIGN KEY (customer_id) REFERENCES my_subway.customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_arrivals_departures_train_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_arrivals_departures
        ADD CONSTRAINT trains_arrivals_departures_train_fk FOREIGN KEY (train_id) REFERENCES my_subway.trains(train_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_arrivals_departures_station_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_arrivals_departures
        ADD CONSTRAINT trains_arrivals_departures_station_fk FOREIGN KEY (station_id) REFERENCES my_subway.stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_stations_ticket_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets_stations
        ADD CONSTRAINT tickets_stations_ticket_fk FOREIGN KEY (ticket_id) REFERENCES my_subway.tickets(ticket_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_stations_station_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets_stations
        ADD CONSTRAINT tickets_stations_station_fk FOREIGN KEY (station_id) REFERENCES my_subway.stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_stations_route_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_stations
        ADD CONSTRAINT routes_stations_route_fk FOREIGN KEY (route_id) REFERENCES my_subway.routes(route_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_stations_station_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_stations
        ADD CONSTRAINT routes_stations_station_fk FOREIGN KEY (station_id) REFERENCES my_subway.stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_employees_employee_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_employees
        ADD CONSTRAINT stations_employees_employee_fk FOREIGN KEY (employee_id) REFERENCES my_subway.employees(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_employees_station_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_employees
        ADD CONSTRAINT stations_employees_station_fk FOREIGN KEY (station_id) REFERENCES my_subway.stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_lines_line_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_lines
        ADD CONSTRAINT stations_lines_line_fk FOREIGN KEY (line_id) REFERENCES my_subway.lines(line_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_lines_station_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_lines
        ADD CONSTRAINT stations_lines_station_fk FOREIGN KEY (station_id) REFERENCES my_subway.stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_trains_line_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines_trains
        ADD CONSTRAINT lines_trains_line_fk FOREIGN KEY (line_id) REFERENCES my_subway.lines(line_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_trains_train_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines_trains
        ADD CONSTRAINT lines_trains_train_fk FOREIGN KEY (train_id) REFERENCES my_subway.trains(train_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_trains_route_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_trains
        ADD CONSTRAINT routes_trains_route_fk FOREIGN KEY (route_id) REFERENCES my_subway.routes(route_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_trains_train_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_trains
        ADD CONSTRAINT routes_trains_train_fk FOREIGN KEY (train_id) REFERENCES my_subway.trains(train_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_employees_employee_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_employees
        ADD CONSTRAINT trains_employees_employee_fk FOREIGN KEY (employee_id) REFERENCES my_subway.employees(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_employees_train_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_employees
        ADD CONSTRAINT trains_employees_train_fk FOREIGN KEY (train_id) REFERENCES my_subway.trains(train_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employees_shifts_employee_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.employees_shifts
        ADD CONSTRAINT employees_shifts_employee_fk FOREIGN KEY (employee_id) REFERENCES my_subway.employees(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'employees_shifts_shift_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.employees_shifts
        ADD CONSTRAINT employees_shifts_shift_fk FOREIGN KEY (shift_id) REFERENCES my_subway.shifts(shift_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_maintances_maintance_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_maintances
        ADD CONSTRAINT trains_maintances_maintance_fk FOREIGN KEY (maintance_id) REFERENCES my_subway.maintances(maintance_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_maintances_train_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_maintances
        ADD CONSTRAINT trains_maintances_train_fk FOREIGN KEY (train_id) REFERENCES my_subway.trains(train_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_maintances_maintance_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_maintances
        ADD CONSTRAINT routes_maintances_maintance_fk FOREIGN KEY (maintance_id) REFERENCES my_subway.maintances(maintance_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_maintances_route_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes_maintances
        ADD CONSTRAINT routes_maintances_route_fk FOREIGN KEY (route_id) REFERENCES my_subway.routes(route_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tracks_maintances_maintance_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks_maintances
        ADD CONSTRAINT tracks_maintances_maintance_fk FOREIGN KEY (maintance_id) REFERENCES my_subway.maintances(maintance_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tracks_maintances_track_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks_maintances
        ADD CONSTRAINT tracks_maintances_track_fk FOREIGN KEY (track_id) REFERENCES my_subway.tracks(track_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tunnels_maintances_maintance_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tunnels_maintances
        ADD CONSTRAINT tunnels_maintances_maintance_fk FOREIGN KEY (maintance_id) REFERENCES my_subway.maintances(maintance_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tunnels_maintances_tunnel_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tunnels_maintances
        ADD CONSTRAINT tunnels_maintances_tunnel_fk FOREIGN KEY (tunnel_id) REFERENCES my_subway.tunnels(tunnel_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_maintances_maintance_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines_maintances
        ADD CONSTRAINT lines_maintances_maintance_fk FOREIGN KEY (maintance_id) REFERENCES my_subway.maintances(maintance_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_maintances_line_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines_maintances
        ADD CONSTRAINT lines_maintances_line_fk FOREIGN KEY (line_id) REFERENCES my_subway.lines(line_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_maintances_maintance_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_maintances
        ADD CONSTRAINT stations_maintances_maintance_fk FOREIGN KEY (maintance_id) REFERENCES my_subway.maintances(maintance_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_maintances_station_fk'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations_maintances
        ADD CONSTRAINT stations_maintances_station_fk FOREIGN KEY (station_id) REFERENCES my_subway.stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
END $$;


/* Adding CHECK constraint, while checking if this CHECK constraint exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'trains_employees_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains
        ADD CONSTRAINT trains_employees_check CHECK (req_number_of_employees > 0);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lines_employees_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines
        ADD CONSTRAINT lines_employees_check CHECK (req_number_of_employees > 0);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'routes_employees_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes
        ADD CONSTRAINT routes_employees_check CHECK (req_number_of_employees > 0);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'stations_employees_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations
        ADD CONSTRAINT stations_employees_check CHECK (req_number_of_employees > 0);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'shifts_startTime_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.shifts
        ADD CONSTRAINT shifts_startTime_check CHECK (shift_startTime > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'shifts_endTime_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.shifts
        ADD CONSTRAINT shifts_endTime_check CHECK (shift_endTime > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_startDate_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets
        ADD CONSTRAINT tickets_startDate_check CHECK (ticket_startDate > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_expireDate_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets
        ADD CONSTRAINT tickets_expireDate_check CHECK (ticket_expireDate > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'arrivals_departures_arrival_time_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_arrivals_departures
        ADD CONSTRAINT arrivals_departures_arrival_time_check CHECK (arrival_time > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'arrivals_departures_departure_time_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains_arrivals_departures
        ADD CONSTRAINT arrivals_departures_departure_time_check CHECK (departure_time > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tickets_time_of_use_check'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tickets_stations
        ADD CONSTRAINT tickets_time_of_use_check CHECK (time_of_use > '2000-01-01 00:00:00+00'::timestamp);
    END IF;
END $$;

/* Adding UNIQUE constraint, while checking if this UNIQUE constraint exists */

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'train_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.trains
        ADD CONSTRAINT train_name_unique UNIQUE (train_name);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'line_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.lines
        ADD CONSTRAINT line_name_unique UNIQUE (line_name);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'route_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.routes
        ADD CONSTRAINT route_name_unique UNIQUE (route_name);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'station_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.stations
        ADD CONSTRAINT station_name_unique UNIQUE (station_name);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tunnel_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tunnels
        ADD CONSTRAINT tunnel_name_unique UNIQUE (tunnel_name);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'track_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks
        ADD CONSTRAINT track_name_unique UNIQUE (track_name);
    END IF;
   
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'track_name_unique'
        AND connamespace = (
            SELECT oid
            FROM pg_namespace
            WHERE nspname = 'my_subway'
        )
    ) THEN
        ALTER TABLE my_subway.tracks
        ADD CONSTRAINT track_name_unique UNIQUE (track_name);
    END IF;
END $$;
