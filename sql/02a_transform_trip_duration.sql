/*
Use case: Analyze how much time is spent per ride/trip
- Based on date and time factors such as day of week and time of day
- Based on which station is the starting and / or ending station
- Based on age of the rider at time of the ride
- Based on whether the rider is a member or a casual rider
*/

-- dim_station
IF OBJECT_ID('dbo.dim_station') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dbo.dim_station];
END

CREATE EXTERNAL TABLE dbo.dim_station
WITH (
  LOCATION    = 'dbo.dim_station',
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
  DROP EXTERNAL TABLE [dbo].[dbo.dim_rider];
END

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
  LOCATION    = 'dbo.dim_rider',
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

-- dim_rider_age_trip
IF OBJECT_ID('dbo.dim_rider_age_trip') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dbo.dim_rider_age_trip];
END

CREATE EXTERNAL TABLE dbo.dim_rider_age_trip
WITH (
  LOCATION    = 'dbo.dim_rider_age_trip',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
  FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT
  trip_key = t.trip_id,
  age_trip = (SELECT   
    YEAR(t.start_at) - YEAR(r.birthday) -   
    CASE   
      WHEN MONTH(t.start_at) < MONTH(r.birthday)   
          OR (MONTH(t.start_at) = MONTH(birthday) AND DAY(t.start_at) < DAY(birthday))   
      THEN 1   
      ELSE 0
    END)FROM
  staging_trip t
INNER JOIN
  staging_rider r on r.rider_id = t.rider_id;
GO

-- fact_trip_duration
IF OBJECT_ID('dbo.fact_trip_duration') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[fact_trip_duration];
END

CREATE EXTERNAL TABLE dbo.fact_trip_duration
WITH (
  LOCATION    = 'fact_trip_duration',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT
  date_key = DATEADD(HOUR, DATEDIFF(HOUR, 0, start_at), 0),
  rider_age_trip_key = trip_id,
  rider_key = rider_id,
  start_station_key = start_station_id,
  end_station_key = end_station_id,
  duration_in_minutes = DATEDIFF(MINUTE, start_at, ended_at)
FROM staging_trip;
GO

-- Test queries
SELECT TOP 10 * FROM dbo.fact_trip_duration
SELECT TOP 10 * FROM dim_date
SELECT TOP 10 * FROM dim_station
SELECT TOP 10 * FROM dim_rider
SELECT TOP 10 * FROM dim_rider_age_trip
