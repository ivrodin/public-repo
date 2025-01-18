SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.dim_times_procedure(
    OUT username name,
    OUT table_name text,
    OUT procedure_name text,
    OUT rows_updated int,
    OUT rows_inserted int,
    OUT procedure_starttime TEXT,
    OUT status text
) AS $$
DECLARE
    count_before INT;
    count_after INT;
    rows_aff INT;
BEGIN

    username := current_user;
    table_name := 'bl_dm.dim_times';
    procedure_name := 'bl_cl.dim_times_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_dm.dim_times;

	INSERT INTO bl_dm.dim_times (
		time_id,
		time_hourofday,
		time_quarterhour,
		time_minuteofday,
		time_daytimename,
		time_daynightname
	)
	select to_char(minute, 'hh24:mi') AS TimeOfDay,
		-- Hour of the day (0 - 23)
		extract(hour from minute) as Hour,
		-- Extract and format quarter hours
		to_char(minute - (extract(minute from minute)::integer % 15 || 'minutes')::interval, 'hh24:mi') ||
		' – ' ||
		to_char(minute - (extract(minute from minute)::integer % 15 || 'minutes')::interval + '14 minutes'::interval, 'hh24:mi')
			as QuarterHour,
		-- Minute of the day (0 - 1439)
		extract(hour from minute)*60 + extract(minute from minute) as minute,
		-- Names of day periods
		case when to_char(minute, 'hh24:mi') between '06:00' and '08:29'
			then 'Morning'
		     when to_char(minute, 'hh24:mi') between '08:30' and '11:59'
			then 'AM'
		     when to_char(minute, 'hh24:mi') between '12:00' and '17:59'
			then 'PM'
		     when to_char(minute, 'hh24:mi') between '18:00' and '22:29'
			then 'Evening'
		     else 'Night'
		end as DaytimeName,
		-- Indicator of day or night
		case when to_char(minute, 'hh24:mi') between '07:00' and '19:59' then 'Day'
		     else 'Night'
		end AS DayNight
	from (SELECT '0:00'::time + (sequence.minute || ' minutes')::interval AS minute
		FROM generate_series(0,1439) AS sequence(minute)
		GROUP BY sequence.minute
	     ) DQ
	WHERE NOT EXISTS (
	    SELECT 1
	    FROM bl_dm.dim_times
	    WHERE time_id = to_char(DQ.minute, 'hh24:mi')
	)
	order by 1;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_dm.dim_times;

    rows_inserted := count_after - count_before;
    rows_updated := rows_aff - rows_inserted;

EXCEPTION
    WHEN OTHERS THEN
        status := 'Error: ' || SQLERRM;
        rows_updated := 0;
        rows_inserted := 0;

--	COMMIT;
END;
$$ LANGUAGE plpgsql;
