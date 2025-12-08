CREATE TABLE [dbo].[Out_stock_cluster2] (

	[Date] date NULL, 
	[Zone] varchar(8000) NULL, 
	[SA_name] varchar(8000) NULL, 
	[Territory] varchar(8000) NULL, 
	[Cluster] varchar(8000) NULL, 
	[#Distinct_HVC] bigint NULL, 
	[#day_HVC] float NULL, 
	[%OOS_HVC] float NULL, 
	[P_OOS] float NULL
);