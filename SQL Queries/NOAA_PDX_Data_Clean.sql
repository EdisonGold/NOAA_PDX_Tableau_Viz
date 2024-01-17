/* Sample data revealing missing data. Focusing on PRCP and Max/Min Temps since 1939. */
USE [Weather]


/* Sampling data to get a view of columns */
SELECT TOP 200 * 
FROM noaa_pdx


/* Checking for missing data */
SELECT *
FROM noaa_pdx
WHERE COALESCE(STATION, NAME, DATE, PRCP, TMAX, TMIN, TAVG) IS NULL
/*
Results show an absense of data between 1937 through 03-31-1938.  I'd like to only work with complete years, so we'll just exclude anything pre 1939.
Results also show missing PRCP data for 02/10/1942 and 11/28/1943.  We'll update those null values once. 
*/

/* Adding missing PRCP (precipitation data)
Per https://weatherspark.com/h/m/757/1942/2/Historical-Weather-in-February-1942-in-Portland-Oregon-United-States
https://weatherspark.com/h/m/145223/1943/1/Historical-Weather-in-January-1943-at-Portland-International-Airport-Oregon-United-States
0 inch on 02/10 and 11/28/1943
*/
UPDATE noaa_pdx
SET PRCP = 0
WHERE DATE IN ('1942-02-10', '1943-11-28')


/* For analysis: Monthly temperature and rainfall averages between 1939-2023. Dropping unnecessary columns. */
ALTER TABLE noaa_pdx
DROP COLUMN PSUN, TSUN, WESD
