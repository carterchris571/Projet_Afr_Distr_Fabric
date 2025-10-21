CREATE TABLE [dbo].[Net_adds_cluster] (

	[Date] date NULL, 
	[Zone] varchar(8000) NULL, 
	[Territory] varchar(8000) NULL, 
	[Cluster] varchar(8000) NULL, 
	[GA_day] bigint NULL, 
	[GA_day_perf] float NULL, 
	[GA_MTD] bigint NULL, 
	[GA_MTD_gap] float NULL, 
	[GA_MTD_perf] float NULL, 
	[Net_adds] bigint NULL, 
	[Target_GA_day] float NULL
);