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
