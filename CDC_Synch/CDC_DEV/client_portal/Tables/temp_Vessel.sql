CREATE TABLE [client_portal].[temp_Vessel](
	[VesselTypeId] [int] NULL,
	[FlagCountryId] [int] NULL,
	[Flag] [varchar](500) NULL,
	[RegistryPortId] [int] NULL,
	[SourceSystemId] [int] NULL,
	[SourceTransactionId] [varchar](100) NULL,
	[RegistryPort] [varchar](2000) NULL,
	[Name] [varchar](200) NULL,
	[Imo] [varchar](200) NULL,
	[CallSign] [varchar](500) NULL,
	[OfficialNumber] [varchar](2000) NULL,
	[Class] [varchar](2000) NULL,
	[Phone] [varchar](2000) NULL,
	[BudgetedCrewCount] [varchar](2000) NULL,
	[LastDryDockDateUtc] [varchar](2000) NULL,
	[NextDryDockDateUtc] [int] NULL,
	[LastUwcUwiDateUtc] [int] NULL,
	[NextUwcUwiDateUtc] [varchar](2000) NULL,
	[LastInspectionDateUtc] [int] NULL,
	[NextInspectionDateUtc] [int] NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL
) ON [PRIMARY]