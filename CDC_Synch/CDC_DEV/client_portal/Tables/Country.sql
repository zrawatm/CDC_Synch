CREATE TABLE [client_portal].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](80) NULL,
	[Iso3] [char](3) NULL,
	[Iso2] [char](2) NULL,
	[CreatedOnUtc] [datetime] NULL,
 CONSTRAINT [pk_country_id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO