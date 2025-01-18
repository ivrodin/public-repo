CREATE SCHEMA IF NOT EXISTS bl_dm;

CREATE TABLE IF NOT EXISTS bl_dm.dim_times(
	time_id varchar(10) PRIMARY KEY,
	time_hourofday int,
	time_quarterhour varchar(20),
	time_minuteofday int,
	time_daytimename varchar(20),
	time_daynightname varchar(20)
);
