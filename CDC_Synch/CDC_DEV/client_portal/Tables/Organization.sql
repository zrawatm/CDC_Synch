CREATE TABLE [client_portal].[Organization](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NULL,
	[Name] [varchar](500) NULL,
	[LogoUrl] [varchar](500) NULL,
	[Type] [varchar](500) NULL,
	[SourceSystemId] [int] NULL,
	[OrganizationAeCode] [varchar](100) NULL,
	[CreatedOnUtc] [datetime] NULL,
 CONSTRAINT [pk_Organization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]