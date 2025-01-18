SET ROLE developer_role;

CREATE OR REPLACE PROCEDURE bl_cl.dim_dates_procedure(
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
    table_name := 'bl_dm.dim_dates';
    procedure_name := 'bl_cl.dim_dates_procedure';
    procedure_starttime := current_timestamp::text;
	status := 'Success';

    SELECT count(*) INTO count_before FROM bl_dm.dim_dates;

	INSERT INTO bl_dm.dim_dates (
		date_id,
		date_year,
		date_month,
		date_monthname,
		date_monthday,
		date_yearday,
		date_weekdayname,
		date_calendarweek,
		date_formatteddate,
		date_quarter,
		date_yearquarter,
		date_yearmonth,
		date_yearcalendarweek,
		date_weekend,
		date_georgianholiday,
		date_period,
		date_cwstart,
		date_cwend,
		date_monthstart,
		date_monthend
	)
	SELECT
		datum as Date,
		extract(year from datum) AS Year,
		extract(month from datum) AS Month,
		-- Localized month name
		to_char(datum, 'TMMonth') AS MonthName,
		extract(day from datum) AS Day,
		extract(doy from datum) AS DayOfYear,
		-- Localized weekday
		to_char(datum, 'TMDay') AS WeekdayName,
		-- ISO calendar week
		extract(week from datum) AS CalendarWeek,
		to_char(datum, 'dd. mm. yyyy') AS FormattedDate,
		'Q' || to_char(datum, 'Q') AS Quartal,
		to_char(datum, 'yyyy/"Q"Q') AS YearQuartal,
		to_char(datum, 'yyyy/mm') AS YearMonth,
		-- ISO calendar year and week
		to_char(datum, 'iyyy/IW') AS YearCalendarWeek,
		-- Weekend
		CASE WHEN extract(isodow from datum) in (6, 7) THEN 'Weekend' ELSE 'Weekday' END AS Weekend,
		-- Fixed holidays
	        -- for Georgia
	        CASE WHEN to_char(datum, 'MMDD') IN
	        ('0101', '0107', '0119', '0303', '0308', '0409', '0505', '0509', '0512', '0526', '0828', '1014', '1123')
			THEN 'Holiday' ELSE 'No holiday' END
			AS GeorgianHoliday,
		-- Some periods of the year, adjust for your organisation and country
		CASE WHEN to_char(datum, 'MMDD') BETWEEN '0601' AND '0831' THEN 'Summer season'
		     WHEN to_char(datum, 'MMDD') BETWEEN '1215' AND '1225' THEN 'Christmas season'
		     WHEN to_char(datum, 'MMDD') > '1225' OR to_char(datum, 'MMDD') <= '0106' THEN 'New Year Season'
			ELSE 'Normal' END
			AS Period,
		-- ISO start and end of the week of this date
		datum + (1 - extract(isodow from datum))::integer AS CWStart,
		datum + (7 - extract(isodow from datum))::integer AS CWEnd,
		-- Start and end of the month of this date
		datum + (1 - extract(day from datum))::integer AS MonthStart,
		(datum + (1 - extract(day from datum))::integer + '1 month'::interval)::date - '1 day'::interval AS MonthEnd
	FROM (
		SELECT '2021-01-01'::DATE + sequence.day AS datum
		FROM generate_series(0,1825) AS sequence(day)
		GROUP BY sequence.day
	     ) DQ
	WHERE NOT EXISTS (
	    SELECT 1
	    FROM bl_dm.dim_dates
	    WHERE date_id = datum
	)
	order by 1;

    GET DIAGNOSTICS rows_aff = ROW_COUNT;

    SELECT count(*) INTO count_after FROM bl_dm.dim_dates;

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
