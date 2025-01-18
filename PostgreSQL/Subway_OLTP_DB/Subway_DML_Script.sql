/*Inserting data into the tables*/

INSERT INTO my_subway.customers (customer_name)
SELECT 'JOHN CENA'
WHERE NOT EXISTS (
	SELECT customer_name FROM my_subway.customers
	WHERE upper(customer_name) = 'JOHN CENA'
)
UNION 
SELECT 'DWAYNE JOHNSON'
WHERE NOT EXISTS (
	SELECT customer_name FROM my_subway.customers
	WHERE upper(customer_name) = 'DWAYNE JOHNSON'
)
RETURNING *;

INSERT INTO my_subway.employees (employee_name, employee_role)
SELECT 'SOFIE TURNER', 'CASSIER'
WHERE NOT EXISTS (
	SELECT employee_name , employee_role  FROM my_subway.employees 
	WHERE upper(employee_name) = 'SOFIE TURNER' AND upper(employee_role) = 'CASSIER'
)
UNION
SELECT 'JAMES MATHIEWS', 'TRAIN ENGINEER'
WHERE NOT EXISTS (
	SELECT employee_name , employee_role  FROM my_subway.employees 
	WHERE upper(employee_name) = 'JAMES MATHIEWS' AND upper(employee_role) = 'TRAIN ENGINEER'
)
RETURNING *;

INSERT INTO my_subway.lines (line_name, line_open_time, line_close_time, req_number_of_employees)
SELECT 'GREEN', '6:30:00'::time, '23:30:00'::time, 4
WHERE NOT EXISTS (
	SELECT line_name  FROM my_subway.lines
	WHERE upper(line_name) = 'GREEN' 
)
UNION
SELECT 'BLUE', '6:15:00'::time, '23:45:00'::time, 6
WHERE NOT EXISTS (
	SELECT line_name  FROM my_subway.lines
	WHERE upper(line_name) = 'BLUE' 
)
RETURNING *;

INSERT INTO my_subway.trains (train_name, req_number_of_employees)
SELECT '12BBOH31', 2
WHERE NOT EXISTS (
	SELECT train_name  FROM my_subway.trains
	WHERE upper(train_name) = '12BBOH31' 
)
UNION
SELECT '312HUI91', 2
WHERE NOT EXISTS (
	SELECT train_name  FROM my_subway.trains
	WHERE upper(train_name) = '312HUI91' 
)
RETURNING *;

INSERT INTO my_subway.stations (station_name, req_number_of_employees)
SELECT 'UNDERPASS', 3
WHERE NOT EXISTS (
	SELECT station_name  FROM my_subway.stations
	WHERE upper(station_name) = 'UNDERPASS' 
)
UNION
SELECT 'OVERPASS', 2
WHERE NOT EXISTS (
	SELECT station_name  FROM my_subway.stations
	WHERE upper(station_name) = 'OVERPASS' 
)
RETURNING *;

INSERT INTO my_subway.maintances (last_maintance_date, estimated_maintance_date)
SELECT '2024-01-01'::date, '2024-06-01'::date
WHERE NOT EXISTS (
	SELECT last_maintance_date, estimated_maintance_date FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND estimated_maintance_date = '2024-06-01'::date
)
UNION
SELECT '2023-06-01'::date, '2024-01-01'::date
WHERE NOT EXISTS (
	SELECT last_maintance_date, estimated_maintance_date FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND estimated_maintance_date = '2024-01-01'::date
)
RETURNING *;

INSERT INTO my_subway.shifts (shift_starttime, shift_endtime)
SELECT '2024-01-01 00:00:00+00'::timestamp, '2024-01-01 12:00:00+00'::timestamp
WHERE NOT EXISTS (
	SELECT shift_starttime, shift_endtime FROM my_subway.shifts  
	WHERE shift_starttime = '2024-01-01 00:00:00+00'::timestamp AND shift_endtime = '2024-01-01 12:00:00+00'::timestamp
)
UNION
SELECT '2024-01-01 12:00:00+00'::timestamp, '2024-01-02 00:00:00+00'::timestamp
WHERE NOT EXISTS (
	SELECT shift_starttime, shift_endtime FROM my_subway.shifts  
	WHERE shift_starttime = '2024-01-01 12:00:00+00'::timestamp AND shift_endtime = '2024-01-02 00:00:00+00'::timestamp
)
RETURNING *;

INSERT INTO my_subway.routes (type_of_route, route_name, req_number_of_employees, line_id)
SELECT 'SERVICE'::route_type, 'RTY131', 5, (SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'GREEN')
WHERE NOT EXISTS (
	SELECT type_of_route, route_name, line_id FROM my_subway.routes  
	WHERE type_of_route = 'SERVICE'::route_type AND route_name = 'RTY131' AND line_id = (SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'GREEN')
)
UNION
SELECT 'TRANSPORT'::route_type, 'RTY512', 5, (SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'BLUE')
WHERE NOT EXISTS (
	SELECT type_of_route, route_name, line_id FROM my_subway.routes  
	WHERE type_of_route = 'TRANSPORT'::route_type AND route_name = 'RTY512' AND line_id = (SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'BLUE')
)
RETURNING *;

INSERT INTO my_subway.trains_arrivals_departures (train_id, station_id, arrival_time, departure_time)
SELECT (SELECT train_id FROM my_subway.trains WHERE upper(train_name) = '12BBOH31'),
	(SELECT station_id FROM my_subway.stations WHERE upper(station_name) = 'UNDERPASS'),
	'2024-03-01 12:30:00+00'::timestamp,
	'2024-03-01 12:35:00+00'::timestamp
WHERE NOT EXISTS (
	SELECT train_id, station_id, arrival_time, departure_time FROM my_subway.trains_arrivals_departures  
	WHERE train_id = (SELECT train_id FROM my_subway.trains WHERE upper(train_name) = '12BBOH31') AND 
	station_id  = (SELECT station_id FROM my_subway.stations WHERE upper(station_name) = 'UNDERPASS') AND
	arrival_time = '2024-03-01 12:30:00+00'::timestamp AND 
	departure_time = '2024-03-01 12:35:00+00'::timestamp
)
UNION
SELECT (SELECT train_id FROM my_subway.trains WHERE upper(train_name) = '312HUI91'),
	(SELECT station_id FROM my_subway.stations WHERE upper(station_name) = 'OVERPASS'),
	'2024-03-01 12:40:00+00'::timestamp,
	'2024-03-01 12:45:00+00'::timestamp
WHERE NOT EXISTS (
	SELECT train_id, station_id, arrival_time, departure_time FROM my_subway.trains_arrivals_departures  
	WHERE train_id = (SELECT train_id FROM my_subway.trains WHERE upper(train_name) = '312HUI91') AND 
	station_id  = (SELECT station_id FROM my_subway.stations WHERE upper(station_name) = 'OVERPASS') AND
	arrival_time = '2024-03-01 12:40:00+00'::timestamp AND 
	departure_time = '2024-03-01 12:45:00+00'::timestamp
)
RETURNING *;

INSERT INTO my_subway.tunnels (tunnel_name, line_id)
SELECT 'TUN223', 
	(SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'GREEN')
WHERE NOT EXISTS (
	SELECT tunnel_name, line_id FROM my_subway.tunnels  
	WHERE upper(tunnel_name)  = 'TUN223' AND 
		line_id  = (SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'GREEN')
)
UNION 
SELECT 'TUN334', 
	(SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'BLUE')
WHERE NOT EXISTS (
	SELECT tunnel_name, line_id FROM my_subway.tunnels  
	WHERE upper(tunnel_name)  = 'TUN334' AND 
		line_id  = (SELECT line_id FROM my_subway.lines WHERE upper(line_name) = 'BLUE')
)
RETURNING *;

INSERT INTO my_subway.tracks (track_name, tunnel_id)
SELECT 'TR112',
	(SELECT tunnel_id FROM my_subway.tunnels WHERE upper(tunnel_name) = 'TUN223')
WHERE NOT EXISTS (
	SELECT track_name, tunnel_id FROM my_subway.tracks  
	WHERE upper(track_name)  = 'TR112' AND 
		tunnel_id  = (SELECT tunnel_id FROM my_subway.tunnels WHERE upper(tunnel_name) = 'TUN223')
)
UNION 
SELECT 'TR223',
	(SELECT tunnel_id FROM my_subway.tunnels WHERE upper(tunnel_name) = 'TUN334')
WHERE NOT EXISTS (
	SELECT track_name, tunnel_id FROM my_subway.tracks  
	WHERE upper(track_name)  = 'TR223' AND 
		tunnel_id  = (SELECT tunnel_id FROM my_subway.tunnels WHERE upper(tunnel_name) = 'TUN334')
)
RETURNING *;

INSERT INTO my_subway.tickets (type_of_ticket, ticket_price, ticket_discount, ticket_startdate, ticket_expiredate, customer_id)
SELECT 'LIMITED 60'::ticket_type,
	100,
	0.2,
	'2024-01-01 12:45:00+00'::timestamp,
	'2024-02-01 12:45:00+00'::timestamp,
	(SELECT customer_id  FROM my_subway.customers WHERE upper(customer_name) = 'JOHN CENA')
WHERE NOT EXISTS (
	SELECT type_of_ticket, ticket_startdate, ticket_expiredate, customer_id FROM my_subway.tickets
	WHERE type_of_ticket  = 'LIMITED 60'::ticket_type AND 
		ticket_startdate = '2024-01-01 12:45:00+00'::timestamp AND 
		ticket_expiredate = '2024-02-01 12:45:00+00'::timestamp AND 
		customer_id = (SELECT customer_id  FROM my_subway.customers WHERE upper(customer_name) = 'JOHN CENA')
)
UNION  
SELECT 'UNLIMITED'::ticket_type,
	200,
	0,
	'2024-02-01 08:30:00+00'::timestamp,
	'2024-03-01 08:30:00+00'::timestamp,
	(SELECT customer_id  FROM my_subway.customers WHERE upper(customer_name) = 'DWAYNE JOHNSON')
WHERE NOT EXISTS (
	SELECT type_of_ticket, ticket_startdate, ticket_expiredate, customer_id FROM my_subway.tickets
	WHERE type_of_ticket  = 'UNLIMITED'::ticket_type AND 
		ticket_startdate = '2024-02-01 08:30:00+00'::timestamp AND 
		ticket_expiredate = '2024-03-01 08:30:00+00'::timestamp AND 
		customer_id = (SELECT customer_id  FROM my_subway.customers WHERE upper(customer_name) = 'DWAYNE JOHNSON')
)
RETURNING *;

INSERT INTO my_subway.tickets_stations (station_id, ticket_id, time_of_use)
SELECT 
	(
	SELECT station_id FROM my_subway.stations 
	WHERE upper(station_name) = 'UNDERPASS'
	),
	(
	SELECT ticket_id FROM my_subway.tickets
	WHERE type_of_ticket  = 'UNLIMITED'::ticket_type AND 
		ticket_startdate = '2024-02-01 08:30:00+00'::timestamp AND 
		ticket_expiredate = '2024-03-01 08:30:00+00'::timestamp AND 
		customer_id = (SELECT customer_id  FROM my_subway.customers WHERE upper(customer_name) = 'DWAYNE JOHNSON')
	),
	'2024-02-01 9:00:00+00'::timestamp
WHERE NOT EXISTS (
	SELECT station_id, ticket_id, time_of_use FROM my_subway.tickets_stations
	WHERE 
		station_id  = ( SELECT station_id FROM my_subway.stations 
		WHERE upper(station_name) = 'UNDERPASS') AND 
		ticket_id = (SELECT ticket_id FROM my_subway.tickets
			WHERE type_of_ticket  = 'UNLIMITED'::ticket_type AND 
				ticket_startdate = '2024-02-01 08:30:00+00'::timestamp AND 
				ticket_expiredate = '2024-03-01 08:30:00+00'::timestamp AND 
				customer_id = (SELECT customer_id  FROM my_subway.customers 
					WHERE upper(customer_name) = 'DWAYNE JOHNSON')) AND 
		time_of_use = '2024-02-01 9:00:00+00'::timestamp
)
UNION 
SELECT 
	(
	SELECT station_id FROM my_subway.stations 
	WHERE upper(station_name) = 'OVERPASS'
	),
	(
	SELECT ticket_id FROM my_subway.tickets
	WHERE type_of_ticket  = 'LIMITED 60'::ticket_type AND 
		ticket_startdate = '2024-01-01 12:45:00+00'::timestamp AND 
		ticket_expiredate = '2024-02-01 12:45:00+00'::timestamp AND 
		customer_id = (SELECT customer_id  FROM my_subway.customers WHERE upper(customer_name) = 'JOHN CENA')
	),
	'2024-01-02 9:00:00+00'::timestamp
WHERE NOT EXISTS (
	SELECT station_id, ticket_id, time_of_use FROM my_subway.tickets_stations
	WHERE 
		station_id  = ( SELECT station_id FROM my_subway.stations 
		WHERE upper(station_name) = 'OVERPASS') AND 
		ticket_id = (SELECT ticket_id FROM my_subway.tickets
			WHERE type_of_ticket  = 'LIMITED 60'::ticket_type AND 
				ticket_startdate = '2024-01-01 12:45:00+00'::timestamp AND 
				ticket_expiredate = '2024-02-01 12:45:00+00'::timestamp AND 
				customer_id = (SELECT customer_id  FROM my_subway.customers 
					WHERE upper(customer_name) = 'JOHN CENA')) AND 
		time_of_use = '2024-01-02 9:00:00+00'::timestamp
)
RETURNING *;

INSERT INTO my_subway.stations_lines (station_id, line_id)
SELECT
	(
	SELECT station_id FROM my_subway.stations 
	WHERE upper(station_name) = 'OVERPASS'
	),
	(
	SELECT line_id FROM my_subway.lines
	WHERE upper(line_name) = 'BLUE'
	)
WHERE NOT EXISTS (
	SELECT station_id , line_id FROM my_subway.stations_lines 
	WHERE 
		station_id = (SELECT station_id FROM my_subway.stations 
			WHERE upper(station_name) = 'OVERPASS') AND 
		line_id = (SELECT line_id FROM my_subway.lines
			WHERE upper(line_name) = 'BLUE')
)
UNION 
SELECT
	(
	SELECT station_id FROM my_subway.stations 
	WHERE upper(station_name) = 'UNDERPASS'
	),
	(
	SELECT line_id FROM my_subway.lines
	WHERE upper(line_name) = 'GREEN'
	)
WHERE NOT EXISTS (
	SELECT station_id , line_id FROM my_subway.stations_lines 
	WHERE 
		station_id = (SELECT station_id FROM my_subway.stations 
			WHERE upper(station_name) = 'UNDERPASS') AND 
		line_id = (SELECT line_id FROM my_subway.lines
			WHERE upper(line_name) = 'GREEN')
)
RETURNING *;

INSERT INTO my_subway.stations_employees (station_id, employee_id)
SELECT
	(
	SELECT station_id FROM my_subway.stations 
	WHERE upper(station_name) = 'OVERPASS'
	),
	(
	SELECT employee_id FROM my_subway.employees
	WHERE upper(employee_name) = 'JAMES MATHIEWS' AND 
	employee_role = 'TRAIN ENGINEER'
	)
WHERE NOT EXISTS (
	SELECT station_id , employee_id  FROM my_subway.stations_employees  
	WHERE 
		station_id = (SELECT station_id FROM my_subway.stations 
			WHERE upper(station_name) = 'OVERPASS') AND 
		employee_id = (SELECT employee_id FROM my_subway.employees
			WHERE upper(employee_name) = 'JAMES MATHIEWS' AND 
				employee_role = 'TRAIN ENGINEER')
)
UNION 
SELECT
	(
	SELECT station_id FROM my_subway.stations 
	WHERE upper(station_name) = 'UNDERPASS'
	),
	(
	SELECT employee_id FROM my_subway.employees
	WHERE upper(employee_name) = 'SOFIE TURNER' AND 
	employee_role = 'CASSIER'
	)
WHERE NOT EXISTS (
	SELECT station_id , employee_id  FROM my_subway.stations_employees  
	WHERE 
		station_id = (SELECT station_id FROM my_subway.stations 
			WHERE upper(station_name) = 'UNDERPASS') AND 
		employee_id = (SELECT employee_id FROM my_subway.employees
			WHERE upper(employee_name) = 'SOFIE TURNER' AND 
				employee_role = 'CASSIER')
)
RETURNING *;

INSERT INTO my_subway.trains_employees (train_id, employee_id)
SELECT
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '12BBOH31'
	),
	(
	SELECT employee_id FROM my_subway.employees
	WHERE upper(employee_name) = 'SOFIE TURNER' AND 
	employee_role = 'CASSIER'
	)
WHERE NOT EXISTS (
	SELECT train_id, employee_id  FROM my_subway.trains_employees  
	WHERE 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '12BBOH31') AND 
		employee_id = (SELECT employee_id FROM my_subway.employees
			WHERE upper(employee_name) = 'SOFIE TURNER' AND 
				employee_role = 'CASSIER')
)
UNION 
SELECT
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '312HUI91'
	),
	(
	SELECT employee_id FROM my_subway.employees
	WHERE upper(employee_name) = 'JAMES MATHIEWS' AND 
	employee_role = 'TRAIN ENGINEER'
	)
WHERE NOT EXISTS (
	SELECT train_id, employee_id  FROM my_subway.trains_employees  
	WHERE 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '312HUI91') AND 
		employee_id = (SELECT employee_id FROM my_subway.employees
			WHERE upper(employee_name) = 'JAMES MATHIEWS' AND 
				employee_role = 'TRAIN ENGINEER')
)
RETURNING *;

INSERT INTO my_subway.routes_trains (route_id, train_id)
SELECT
	(
	SELECT route_id  FROM my_subway.routes
	WHERE upper(route_name) = 'RTY131'
	),
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '312HUI91'
	)
WHERE NOT EXISTS (
	SELECT route_id, train_id  FROM my_subway.routes_trains 
	WHERE 
		route_id = (SELECT route_id  FROM my_subway.routes
			WHERE upper(route_name) = 'RTY131') AND 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '312HUI91')
)
UNION 
SELECT
	(
	SELECT route_id  FROM my_subway.routes
	WHERE upper(route_name) = 'RTY512'
	),
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '12BBOH31'
	)
WHERE NOT EXISTS (
	SELECT route_id, train_id  FROM my_subway.routes_trains 
	WHERE 
		route_id = (SELECT route_id  FROM my_subway.routes
			WHERE upper(route_name) = 'RTY512') AND 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '12BBOH31')
)
RETURNING *;

INSERT INTO my_subway.lines_trains  (line_id, train_id)
SELECT
	(
	SELECT line_id  FROM my_subway.lines 
	WHERE upper(line_name) = 'BLUE'
	),
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '312HUI91'
	)
WHERE NOT EXISTS (
	SELECT line_id, train_id FROM my_subway.lines_trains
	WHERE 
		line_id = (SELECT line_id  FROM my_subway.lines 
			WHERE upper(line_name) = 'BLUE') AND 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '312HUI91')
)
UNION 
SELECT
	(
	SELECT line_id  FROM my_subway.lines 
	WHERE upper(line_name) = 'GREEN'
	),
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '12BBOH31'
	)
WHERE NOT EXISTS (
	SELECT line_id, train_id FROM my_subway.lines_trains
	WHERE 
		line_id = (SELECT line_id  FROM my_subway.lines 
			WHERE upper(line_name) = 'GREEN') AND 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '12BBOH31')
)
RETURNING *;

INSERT INTO my_subway.routes_stations (route_id, station_id)
SELECT
	(
	SELECT route_id  FROM my_subway.routes
	WHERE upper(route_name) = 'RTY131'
	),
	(
	SELECT station_id  FROM my_subway.stations
	WHERE upper(station_name) = 'OVERPASS'
	)
WHERE NOT EXISTS (
	SELECT route_id, station_id  FROM my_subway.routes_stations
	WHERE 
		route_id = (SELECT route_id  FROM my_subway.routes
			WHERE upper(route_name) = 'RTY131') AND 
		station_id = (SELECT station_id  FROM my_subway.stations
			WHERE upper(station_name) = 'OVERPASS')
)
UNION 
SELECT
	(
	SELECT route_id  FROM my_subway.routes
	WHERE upper(route_name) = 'RTY512'
	),
	(
	SELECT station_id  FROM my_subway.stations
	WHERE upper(station_name) = 'UNDERPASS'
	)
WHERE NOT EXISTS (
	SELECT route_id, station_id  FROM my_subway.routes_stations
	WHERE 
		route_id = (SELECT route_id  FROM my_subway.routes
			WHERE upper(route_name) = 'RTY512') AND 
		station_id = (SELECT station_id  FROM my_subway.stations
			WHERE upper(station_name) = 'UNDERPASS')
)
RETURNING *;

INSERT INTO my_subway.routes_maintances (route_id, maintance_id)
SELECT
	(
	SELECT route_id  FROM my_subway.routes
	WHERE upper(route_name) = 'RTY131'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND 
		estimated_maintance_date = '2024-01-01'::date
	)
WHERE NOT EXISTS (
	SELECT route_id, maintance_id  FROM my_subway.routes_maintances
	WHERE 
		route_id = (SELECT route_id  FROM my_subway.routes
			WHERE upper(route_name) = 'RTY131') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2023-06-01'::date AND 
				estimated_maintance_date = '2024-01-01'::date)
)
UNION 
SELECT
	(
	SELECT route_id  FROM my_subway.routes
	WHERE upper(route_name) = 'RTY512'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND 
		estimated_maintance_date = '2024-06-01'::date
	)
WHERE NOT EXISTS (
	SELECT route_id, maintance_id  FROM my_subway.routes_maintances
	WHERE 
		route_id = (SELECT route_id  FROM my_subway.routes
			WHERE upper(route_name) = 'RTY512') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2024-01-01'::date AND 
				estimated_maintance_date = '2024-06-01'::date)
)
RETURNING *;

INSERT INTO my_subway.trains_maintances (train_id, maintance_id)
SELECT
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '12BBOH31'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND 
		estimated_maintance_date = '2024-01-01'::date
	)
WHERE NOT EXISTS (
	SELECT train_id, maintance_id  FROM my_subway.trains_maintances
	WHERE 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '12BBOH31') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2023-06-01'::date AND 
				estimated_maintance_date = '2024-01-01'::date)
)
UNION 
SELECT
	(
	SELECT train_id  FROM my_subway.trains
	WHERE upper(train_name) = '312HUI91'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND 
		estimated_maintance_date = '2024-06-01'::date
	)
WHERE NOT EXISTS (
	SELECT train_id, maintance_id  FROM my_subway.trains_maintances
	WHERE 
		train_id = (SELECT train_id  FROM my_subway.trains
			WHERE upper(train_name) = '312HUI91') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2024-01-01'::date AND 
				estimated_maintance_date = '2024-06-01'::date)
)
RETURNING *;

INSERT INTO my_subway.stations_maintances (station_id, maintance_id)
SELECT
	(
	SELECT station_id  FROM my_subway.stations 
	WHERE upper(station_name) = 'OVERPASS'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND 
		estimated_maintance_date = '2024-01-01'::date
	)
WHERE NOT EXISTS (
	SELECT station_id, maintance_id  FROM my_subway.stations_maintances
	WHERE 
		station_id = (SELECT station_id  FROM my_subway.stations 
			WHERE upper(station_name) = 'OVERPASS') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2023-06-01'::date AND 
				estimated_maintance_date = '2024-01-01'::date)
)
UNION 
SELECT
	(
	SELECT station_id  FROM my_subway.stations 
	WHERE upper(station_name) = 'UNDERPASS'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND 
		estimated_maintance_date = '2024-06-01'::date
	)
WHERE NOT EXISTS (
	SELECT station_id, maintance_id  FROM my_subway.stations_maintances
	WHERE 
		station_id = (SELECT station_id  FROM my_subway.stations 
			WHERE upper(station_name) = 'UNDERPASS') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2024-01-01'::date AND 
				estimated_maintance_date = '2024-06-01'::date)
)
RETURNING *;

INSERT INTO my_subway.lines_maintances (line_id, maintance_id)
SELECT
	(
	SELECT line_id  FROM my_subway.lines 
	WHERE upper(line_name) = 'BLUE'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND 
		estimated_maintance_date = '2024-01-01'::date
	)
WHERE NOT EXISTS (
	SELECT line_id, maintance_id  FROM my_subway.lines_maintances
	WHERE 
		line_id = (SELECT line_id  FROM my_subway.lines 
			WHERE upper(line_name) = 'BLUE') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2023-06-01'::date AND 
				estimated_maintance_date = '2024-01-01'::date)
)
UNION 
SELECT
	(
	SELECT line_id  FROM my_subway.lines 
	WHERE upper(line_name) = 'GREEN'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND 
		estimated_maintance_date = '2024-06-01'::date
	)
WHERE NOT EXISTS (
	SELECT line_id, maintance_id  FROM my_subway.lines_maintances
	WHERE 
		line_id = (SELECT line_id  FROM my_subway.lines 
			WHERE upper(line_name) = 'GREEN') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2024-01-01'::date AND 
				estimated_maintance_date = '2024-06-01'::date)
)
RETURNING *;

INSERT INTO my_subway.tunnels_maintances (tunnel_id, maintance_id)
SELECT
	(
	SELECT tunnel_id  FROM my_subway.tunnels 
	WHERE upper(tunnel_name) = 'TUN223'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND 
		estimated_maintance_date = '2024-01-01'::date
	)
WHERE NOT EXISTS (
	SELECT tunnel_id, maintance_id  FROM my_subway.tunnels_maintances
	WHERE 
		tunnel_id = (SELECT tunnel_id  FROM my_subway.tunnels 
			WHERE upper(tunnel_name) = 'TUN223') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2023-06-01'::date AND 
				estimated_maintance_date = '2024-01-01'::date)
)
UNION 
SELECT
	(
	SELECT tunnel_id  FROM my_subway.tunnels 
	WHERE upper(tunnel_name) = 'TUN334'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND 
		estimated_maintance_date = '2024-06-01'::date
	)
WHERE NOT EXISTS (
	SELECT tunnel_id, maintance_id  FROM my_subway.tunnels_maintances
	WHERE 
		tunnel_id = (SELECT tunnel_id  FROM my_subway.tunnels 
			WHERE upper(tunnel_name) = 'TUN334') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2024-01-01'::date AND 
				estimated_maintance_date = '2024-06-01'::date)
)
RETURNING *;

INSERT INTO my_subway.tracks_maintances (track_id, maintance_id)
SELECT
	(
	SELECT track_id  FROM my_subway.tracks 
	WHERE upper(track_name) = 'TR112'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2023-06-01'::date AND 
		estimated_maintance_date = '2024-01-01'::date
	)
WHERE NOT EXISTS (
	SELECT track_id, maintance_id  FROM my_subway.tracks_maintances
	WHERE 
		track_id = (SELECT track_id  FROM my_subway.tracks 
			WHERE upper(track_name) = 'TR112') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2023-06-01'::date AND 
				estimated_maintance_date = '2024-01-01'::date)
)
UNION 
SELECT
	(
	SELECT track_id  FROM my_subway.tracks 
	WHERE upper(track_name) = 'TR223'
	),
	(
	SELECT maintance_id  FROM my_subway.maintances 
	WHERE last_maintance_date = '2024-01-01'::date AND 
		estimated_maintance_date = '2024-06-01'::date
	)
WHERE NOT EXISTS (
	SELECT track_id, maintance_id  FROM my_subway.tracks_maintances
	WHERE 
		track_id = (SELECT track_id  FROM my_subway.tracks 
			WHERE upper(track_name) = 'TR223') AND 
		maintance_id = (SELECT maintance_id  FROM my_subway.maintances 
			WHERE last_maintance_date = '2024-01-01'::date AND 
				estimated_maintance_date = '2024-06-01'::date)
)
RETURNING *;

INSERT INTO my_subway.employees_shifts  (employee_id , shift_id)
SELECT
	(
	SELECT employee_id FROM my_subway.employees
	WHERE upper(employee_name) = 'JAMES MATHIEWS' AND 
		employee_role = 'TRAIN ENGINEER'
	),
	(
	SELECT shift_id FROM my_subway.shifts  
	WHERE shift_starttime = '2024-01-01 00:00:00+00'::timestamp AND 
		shift_endtime = '2024-01-01 12:00:00+00'::timestamp
	)
WHERE NOT EXISTS (
	SELECT employee_id , shift_id  FROM my_subway.employees_shifts
	WHERE 
		employee_id = (SELECT employee_id FROM my_subway.employees
			WHERE upper(employee_name) = 'JAMES MATHIEWS' AND 
				employee_role = 'TRAIN ENGINEER') AND 
		shift_id  = (SELECT shift_id FROM my_subway.shifts  
			WHERE shift_starttime = '2024-01-01 00:00:00+00'::timestamp AND 
				shift_endtime = '2024-01-01 12:00:00+00'::timestamp)
)
UNION 
SELECT
	(
	SELECT employee_id FROM my_subway.employees
	WHERE upper(employee_name) = 'SOFIE TURNER' AND 
		employee_role = 'CASSIER'
	),
	(
	SELECT shift_id FROM my_subway.shifts  
	WHERE shift_starttime = '2024-01-01 12:00:00+00'::timestamp AND 
		shift_endtime = '2024-01-02 00:00:00+00'::timestamp
	)
WHERE NOT EXISTS (
	SELECT employee_id , shift_id  FROM my_subway.employees_shifts
	WHERE 
		employee_id = (SELECT employee_id FROM my_subway.employees
			WHERE upper(employee_name) = 'SOFIE TURNER' AND 
				employee_role = 'CASSIER') AND 
		shift_id  = (SELECT shift_id FROM my_subway.shifts  
			WHERE shift_starttime = '2024-01-01 12:00:00+00'::timestamp AND 
				shift_endtime = '2024-01-02 00:00:00+00'::timestamp)
)
RETURNING *;
