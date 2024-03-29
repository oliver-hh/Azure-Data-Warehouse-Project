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
