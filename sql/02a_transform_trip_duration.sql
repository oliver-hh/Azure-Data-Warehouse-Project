/*
Use case: Analyze how much time is spent per ride/trip
- Based on date and time factors such as day of week and time of day
- Based on which station is the starting and / or ending station
- Based on age of the rider at time of the ride
- Based on whether the rider is a member or a casual rider
*/

-- dim_date_trip
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

-- dim_station
IF OBJECT_ID('dim_station') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_station];
END

CREATE EXTERNAL TABLE dbo.dim_station
WITH (
  LOCATION    = 'dim_station',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
  FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT
  station_key = station_id,
  name
FROM
  staging_station;
GO

-- dim_rider
IF OBJECT_ID('dbo.dim_rider') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_rider];
END

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
  LOCATION    = 'dim_rider',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
  FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT
  rider_key = rider_id,
  age_account_start = (SELECT
    YEAR(account_start_date) - YEAR(birthday) -
    CASE
      WHEN MONTH(account_start_date) < MONTH(birthday)
          OR (MONTH(account_start_date) = MONTH(birthday) AND DAY(account_start_date) < DAY(birthday))
      THEN 1
      ELSE 0
    END),
  is_member
FROM
  staging_rider;

GO

-- fact_trip
IF OBJECT_ID('dbo.fact_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[fact_trip];
END

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
  LOCATION    = 'fact_trip',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT
  date_key = DATEADD(HOUR, DATEDIFF(HOUR, 0, t.start_at), 0),
  rider_age_trip_key = t.trip_id,
  rider_key = t.rider_id,
  start_station_key = t.start_station_id,
  end_station_key = t.end_station_id,
  duration_in_minutes = DATEDIFF(MINUTE, t.start_at, t.ended_at),
  age_trip = (SELECT
    YEAR(t.start_at) - YEAR(r.birthday) -
    CASE
      WHEN MONTH(t.start_at) < MONTH(r.birthday)
          OR (MONTH(t.start_at) = MONTH(birthday) AND DAY(t.start_at) < DAY(birthday))
      THEN 1
      ELSE 0
    END) 
FROM staging_trip t
INNER JOIN staging_rider r on r.rider_id = t.rider_id;
GO

-- Test queries
SELECT TOP 10 * FROM fact_trip
SELECT TOP 10 * FROM dim_date_trip
SELECT TOP 10 * FROM dim_station
SELECT TOP 10 * FROM dim_rider
