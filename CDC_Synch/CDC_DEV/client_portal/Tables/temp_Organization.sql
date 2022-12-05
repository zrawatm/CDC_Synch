CREATE TABLE [client_portal].[temp_Organization](
	[CountryId] [int] NULL,
	[Name] [varchar](100) NULL,
	[Type] [varchar](6) NOT NULL,
	[SourceSystemId] [int] NULL,
	[OrganizationAeCode] [varchar](100) NULL,
	[CreatedOnUtc] [datetime] NOT NULL
) ON [PRIMARY]