CREATE TABLE [cis].[csm02](
	[port_code] [varchar](4) NULL,
	[port_name] [varchar](20) NULL,
	[country] [varchar](30) NULL,
	[port_rem] [varchar](max) NULL,
	[site] [varchar](5) NULL,
	[keyfld] [varchar](10) NULL,
	[rowguid] [varchar](36) NULL,
	[cdc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[cdc_creation_date] [datetime] NULL,
	[cdc_modified_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO