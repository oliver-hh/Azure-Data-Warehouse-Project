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
