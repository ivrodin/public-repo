CREATE SCHEMA IF NOT EXISTS bl_dm;

CREATE TABLE IF NOT EXISTS bl_dm.dim_dates (
	date_id date PRIMARY KEY,
	date_year int,
	date_month int,
	date_monthname varchar(20),
	date_monthday int,
	date_yearday int,
	date_weekdayname varchar(20),
	date_calendarweek int,
	date_formatteddate varchar(20),
	date_quarter varchar(4),
	date_yearquarter varchar(20),
	date_yearmonth varchar (20),
	date_yearcalendarweek varchar(20),
	date_weekend varchar(20),
	date_georgianholiday varchar(20),
	date_period varchar(50),
	date_cwstart date,
	date_cwend date,
	date_monthstart date,
	date_monthend timestamp
);
