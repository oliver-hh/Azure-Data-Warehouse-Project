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
