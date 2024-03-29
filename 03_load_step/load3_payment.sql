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
