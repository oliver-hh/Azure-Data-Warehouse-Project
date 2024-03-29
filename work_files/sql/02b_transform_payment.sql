-- dim_rider can be reused

-- dim_date_payment (created from payment)
IF OBJECT_ID('dbo.dim_date_payment') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_date_payment];
END

CREATE EXTERNAL TABLE dbo.dim_date_payment
WITH (
  LOCATION    = 'dim_date_payment',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT DISTINCT
  date_key = DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0),
  month = MONTH([date]),
  quarter = DATEPART(QUARTER, [date]),
  year = YEAR([date])
FROM
  staging_payment
ORDER BY
  date_key;
GO

-- fact_payment
IF OBJECT_ID('dbo.fact_payment') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[fact_payment];
END

CREATE EXTERNAL TABLE dbo.fact_payment
WITH (
  LOCATION    = 'fact_payment',
  DATA_SOURCE = [udacity-divvy_dlsazdelab_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT
  date_key = DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0),
  rider_key = rider_id,
  amount_dollar = sum(amount)
FROM staging_payment
GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0), rider_id
ORDER BY DATEADD(MONTH, DATEDIFF(MONTH, 0, date), 0), rider_id;
GO


SELECT * FROM dim_date_payment
SELECT TOP 100 * FROM fact_payment

