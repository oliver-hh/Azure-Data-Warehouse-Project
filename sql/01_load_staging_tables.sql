------------------------------------------------
-- Create external file format and data source
------------------------------------------------

-- DROP EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat]
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 STRING_DELIMITER = '"',
			 FIRST_ROW = 2,
			 USE_TYPE_DEFAULT = FALSE
			))
GO

-- DROP EXTERNAL DATA SOURCE [udacity-divvy_dlsazdelab_dfs_core_windows_net] 
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacity-divvy_dlsazdelab_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacity-divvy_dlsazdelab_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacity-divvy@dlsazdelab.dfs.core.windows.net' 
	)
GO

------------------------------------------------
-- Load table staging_station
------------------------------------------------

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

------------------------------------------------
-- Load table staging_rider
------------------------------------------------

--DROP EXTERNAL TABLE dbo.staging_rider
CREATE EXTERNAL TABLE dbo.staging_rider (
	[rider_id] bigint,
	[first] nvarchar(50),
	[last] nvarchar(50),
	[address] nvarchar(100),
	[birthday] datetime2(0),
	[account_start_date] datetime2(0),
	[account_end_date] datetime2(0),
	[is_member] bit
	)
	WITH (
	LOCATION = 'rider.csv',
	DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO

------------------------------------------------
-- Load table staging_payment
------------------------------------------------

--DROP EXTERNAL TABLE dbo.staging_payment
CREATE EXTERNAL TABLE dbo.staging_payment (
	[payment_id] bigint,
	[date] datetime2(0),
	[amount] DECIMAL(5,2),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'payment.csv',
	DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO

------------------------------------------------
-- Load table staging_trip
------------------------------------------------

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

------------------------------------------------
-- Check loaded staging tables
------------------------------------------------

SELECT 'staging_station' AS table_name, COUNT(*) AS record_count FROM dbo.staging_station UNION ALL
SELECT 'staging_rider', COUNT(*) FROM dbo.staging_rider UNION ALL
SELECT 'staging_payment', COUNT(*) FROM dbo.staging_payment UNION ALL
SELECT 'staging_trip', COUNT(*) FROM dbo.staging_trip
ORDER BY table_name
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO
SELECT TOP 100 * FROM dbo.staging_rider
GO
SELECT TOP 100 * FROM dbo.staging_station
GO
SELECT TOP 100 * FROM dbo.staging_trip
GO