/*
Objective: Find temperature or precipitation trends for use in Tableau.
1. Create 10-year groupings between 1939-2023 for temperature trends.
2. Analyze monthly and annual averages and sums.
*/

/* Adding a new column for grouping by decade */
USE Weather;

ALTER TABLE noaa_pdx
ADD GROUPED_YEARS VARCHAR(55);

UPDATE noaa_pdx
SET 
	TAVG = (TMAX + TMIN) / 2,
	GROUPED_YEARS = CASE 
		WHEN YEAR(DATE) BETWEEN 1939 AND 1958 THEN '1939-1958'
		WHEN YEAR(DATE) BETWEEN 1959 AND 1978 THEN '1959-1978'
		WHEN YEAR(DATE) BETWEEN 1979 AND 1998 THEN '1979-1998'
		WHEN YEAR(DATE) BETWEEN 1999 AND 2018 THEN '1999-2018'
		WHEN YEAR(DATE) > 2018 THEN '2019 - Present'
	END;

/* Average monthly rainfall in Inch */
SELECT ROUND(AVG(MONTHLY_RAINFALL), 2) AS AVG_MONTHLY_RAINFALL, MONTH
FROM (
	SELECT SUM(PRCP) AS MONTHLY_RAINFALL, MONTH(DATE) AS MONTH, YEAR(DATE) AS YEAR 
	FROM noaa_pdx
	WHERE YEAR(DATE) >= 1939
	GROUP BY MONTH(DATE), YEAR(DATE)
) AS X
GROUP BY MONTH
ORDER BY MONTH;

/* Annual rainfall sums */
SELECT SUM(PRCP) AS ANNUAL_RAINFALL, YEAR(DATE) AS YEAR 
FROM noaa_pdx
WHERE YEAR(DATE) >= 1939
GROUP BY YEAR(DATE)
ORDER BY SUM(PRCP);

/* Average temperature by daily mins and max */
SELECT AVG(TMIN) AS AVG_TMIN, AVG(TMAX) AS AVG_TMAX
FROM noaa_pdx
WHERE DATE >= '01/01/1939';

/* Number of days over 95 degrees by decade grouping */
SELECT COUNT(TMAX) AS DAYS_OVER, GROUPED_YEARS
FROM noaa_pdx
WHERE DATE >= '01/01/1939'
	AND TMAX >= 95
GROUP BY GROUPED_YEARS;
