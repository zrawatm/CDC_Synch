
CREATE TABLE [client_portal].[temp_vessel_master](
	[ship_type] [varchar](500) NULL,
	[ship_name] [varchar](200) NULL,
	[imo] [varchar](200) NULL,
	[active] [int] NOT NULL,
	[call_sign] [varchar](500) NULL,
	[officialno] [varchar](2000) NULL,
	[flag] [varchar](500) NULL,
	[class] [varchar](2000) NULL,
	[primary_contact] [varchar](2000) NULL,
	[takeover_date] [datetime] NULL,
	[handover_date] [datetime] NULL,
	[fos_ship_code] [varchar](3) NULL,
	[port_of_registry] [varchar](2000) NULL,
	[netsuite_ship_code] [varchar](500) NULL,
	[group_owner_name] [varchar](100) NULL,
	[group_owner_country] [varchar](100) NULL,
	[registered_owner_name] [varchar](100) NULL,
	[jibe_ship_code] [varchar](100) NULL,
	[cis_ship_code] [varchar](3) NULL,
	[safe_manning_count] [varchar](2000) NULL,
	[OrganizationAeCode] [varchar](100) NULL,
	[crew_budgeted] [varchar](2000) NULL,
	[current_last_dry_dock_end_date] [varchar](2000) NULL,
	[last_under_water_survey] [varchar](2000) NULL
) ON [PRIMARY]
GO