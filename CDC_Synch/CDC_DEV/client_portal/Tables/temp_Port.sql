CREATE TABLE [client_portal].[temp_Port](
	[CountryId] [int] NULL,
	[Name] [varchar](30) NULL,
	[Abbrevation] [nvarchar](7) NULL,
	[Longitude] [float] NULL,
	[Latitude] [float] NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL
) ON [PRIMARY]