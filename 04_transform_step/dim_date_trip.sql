IF OBJECT_ID('dim_date_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_date_trip];
END

CREATE EXTERNAL TABLE dbo.dim_date_trip
WITH (
  LOCATION = 'dim_date_trip',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
  FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT DISTINCT
  [date_key] = DATEADD(HOUR, DATEDIFF(HOUR, 0, start_at), 0),
	[year] = YEAR(start_at),
	[month] = MONTH(start_at),
	[day] = DAY(start_at),
	[hour] = DATEPART(HOUR, start_at),
	[time_of_day] = CASE
    WHEN DATEPART(HOUR, start_at) BETWEEN 5 AND 11 THEN 'Morning'
    WHEN DATEPART(HOUR, start_at) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN DATEPART(HOUR, start_at) BETWEEN 18 AND 20 THEN 'Evening'
    ELSE 'Night'
  END,
	[quarter] = DATEPART(QUARTER, start_at),
	[week] = DATEPART(WEEK, start_at),
	[day_of_week] = DATEPART(WEEKDAY, start_at),
	[season] = CASE
    WHEN MONTH(start_at) IN (3, 4, 5) THEN 'Spring'
    WHEN MONTH(start_at) IN (6, 7, 8) THEN 'Summer'
    WHEN MONTH(start_at) IN (9, 10, 11) THEN 'Autumn'
    ELSE 'Winter'
  END,
	[is_weekend] = CAST(CASE
    WHEN DATEPART(WEEKDAY, start_at) IN (1, 7) THEN 1
    ELSE 0
  END AS BIT)
FROM
  staging_trip
ORDER BY
  [date_key]
GO