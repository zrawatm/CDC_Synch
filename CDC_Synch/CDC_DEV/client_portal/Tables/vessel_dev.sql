﻿CREATE TABLE [jibe].[vessel_dev](
	[vessel_information_uid] [varchar](200) NULL,
	[vessel_owner] [int] NULL,
	[vessel_types] [varchar](200) NULL,
	[flag] [varchar](200) NULL,
	[registry_port] [varchar](200) NULL,
	[vessel_name] [varchar](200) NULL,
	[imo_code] [varchar](200) NULL,
	[vessel_client_id] [varchar](200) NULL,
	[call_sign] [varchar](200) NULL,
	[official_number] [varchar](200) NULL,
	[class] [varchar](200) NULL,
	[phone] [varchar](200) NULL,
	[vessel_id] [int] NULL,
	[next_dry_dock_date] [datetime] NULL,
	[fleet_director_name] [varchar](200) NULL,
	[fleet_director_mail] [varchar](200) NULL,
	[field_value_for_fleet_director] [varchar](200) NULL,
	[fleet_manager_name] [varchar](200) NULL,
	[fleet_manager_mail] [varchar](200) NULL,
	[field_value_for_fleet_manager] [varchar](200) NULL,
	[vessel_manager_name] [varchar](200) NULL,
	[vessel_manager_mail] [varchar](200) NULL,
	[field_value_for_vessel_manager] [varchar](200) NULL,
	[date_of_creation] [datetime] NULL,
	[date_of_modification] [datetime] NULL,
	[active_status] [varchar](200) NULL,
	[cdc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[cdc_creation_date] [datetime] NULL,
	[cdc_modified_date] [datetime] NULL,
	[rn] [bigint] NULL,
	[short_name] [varchar](100) NULL,
	[group_owner_name] [varchar](100) NULL,
	[registered_owner_name] [varchar](100) NULL,
	[group_owner_country] [varchar](100) NULL,
	[real_ship_code] [varchar](20) NULL,
	[OrganizationAeCode] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[cdc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO