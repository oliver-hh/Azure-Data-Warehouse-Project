IF OBJECT_ID('dbo.dim_rider') IS NOT NULL
BEGIN
  DROP EXTERNAL TABLE [dbo].[dim_rider];
END

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
  LOCATION    = 'dim_rider',
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
