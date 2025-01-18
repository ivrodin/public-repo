-- Created user, granted privileges

-- CREATE USER 'ivan_rodin'@'%' IDENTIFIED BY '1234';
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER , EXECUTE, CREATE ROUTINE, ALTER ROUTINE,
-- CREATE VIEW, SHOW VIEW ON *.* TO 'ivan_rodin'@'%';
-- FLUSH PRIVILEGES;

-- All next steps made by user ivan_rodin

CREATE SCHEMA IF NOT EXISTS rodin_ivan;

DROP TABLE IF EXISTS rodin_ivan.test_table;

CREATE TABLE rodin_ivan.test_table (
	id int,
	name varchar(20),
	insert_dt timestamp DEFAULT current_timestamp
);

DROP PROCEDURE IF EXISTS rodin_ivan.insert_procedure;

DELIMITER //

CREATE PROCEDURE rodin_ivan.insert_procedure()
BEGIN
  INSERT INTO rodin_ivan.test_table (id, name)
  VALUES (1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (5, 'e');
END;// 

DELIMITER ;

CALL rodin_ivan.insert_procedure();

DROP VIEW IF EXISTS rodin_ivan.test_view;

CREATE VIEW rodin_ivan.test_view AS 
SELECT name FROM rodin_ivan.test_table tt
WHERE insert_dt = (SELECT max(insert_dt) FROM rodin_ivan.test_table tt) ;



