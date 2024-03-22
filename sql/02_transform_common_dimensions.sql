IF OBJECT_ID('dbo.dim_date') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_date];
END

CREATE EXTERNAL TABLE dbo.dim_date (
	[date_key] datetime2(0),
	[year] int,
	[month] int,
	[day] int,
	[hour] int,
	[time_of_day] nvarchar(10),
	[quarter] int,
	[week] int,
	[day_of_week] int,
	[season] nvarchar(10),
	[is_weekend_or_holiday] bit
	)
	WITH (
	LOCATION = 'dim_date.csv',
	DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT COUNT(*) from dim_date
SELECT TOP 100 * from dim_date
GO