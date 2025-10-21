CREATE TABLE [dbo].[DTR_DTC_cluster] (

	[Date] date NULL, 
	[Zone] varchar(8000) NULL, 
	[Territory] varchar(8000) NULL, 
	[Cluster] varchar(8000) NULL, 
	[DTR Day Perf] float NULL, 
	[DTR Day] float NULL, 
	[DTC Day] float NULL, 
	[DTC Day Perf] float NULL, 
	[Lo MTD Perf] float NULL, 
	[DTR MTD] float NULL, 
	[DTR MoM] float NULL, 
	[DTR Gap vs LM] float NULL, 
	[DTC MTD] float NULL, 
	[DTC MTD Perf] float NULL, 
	[DTC MoM] float NULL, 
	[DTC Gap vs LM] float NULL, 
	[Target DTR day] float NULL, 
	[Target DTC day] float NULL
);