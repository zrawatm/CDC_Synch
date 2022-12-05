CREATE TABLE [client_portal].[SourceSystem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [varchar](500) NULL,
	[Code] [varchar](500) NULL,
	[CreatedOnUtc] [datetime] NULL,
 CONSTRAINT [pk_SourceSystem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]