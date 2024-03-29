--DROP EXTERNAL TABLE dbo.staging_station
CREATE EXTERNAL TABLE dbo.staging_station (
	[station_id] NVARCHAR(50),
	[name] NVARCHAR(100),
	[latitude] DECIMAL(10,6),
	[longitude] DECIMAL(10,6)
	)
	WITH (
	LOCATION = 'station.csv',
	DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO
