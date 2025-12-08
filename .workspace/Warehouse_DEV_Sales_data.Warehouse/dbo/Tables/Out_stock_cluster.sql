CREATE TABLE [dbo].[Out_stock_cluster] (

	[Date] date NULL, 
	[Zone] varchar(8000) NULL, 
	[SA_name] varchar(8000) NULL, 
	[Territory] varchar(8000) NULL, 
	[Cluster] varchar(8000) NULL, 
	[#Distinct_HVC] float NULL, 
	[Avg Float HV POS] float NULL, 
	[#Avg_HVC_OOS] float NULL, 
	[%OOS_HVC] float NULL, 
	[Avg OOS HV POS rate MoM] float NULL, 
	[#day_HVC] float NULL, 
	[Avg Active POS] float NULL, 
	[P_OOS] float NULL
);