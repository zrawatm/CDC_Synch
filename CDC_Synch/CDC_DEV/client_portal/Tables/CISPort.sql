CREATE TABLE [client_portal].[CISPort](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](500) NULL,
	[PortName] [varchar](500) NULL,
	[Country] [varchar](500) NULL,
	[CreatedOnUtc] [datetime] NULL,
 CONSTRAINT [pk_CISPort] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]