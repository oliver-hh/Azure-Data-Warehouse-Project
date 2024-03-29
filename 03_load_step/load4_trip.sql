--DROP EXTERNAL TABLE dbo.staging_trip
CREATE EXTERNAL TABLE dbo.staging_trip (
	[trip_id] nvarchar(20),
	[rideable_type] nvarchar(20),
	[start_at] datetime2(0),
	[ended_at] datetime2(0),
	[start_station_id] nvarchar(50),
	[end_station_id] nvarchar(50),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'trip.csv',
	DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO
