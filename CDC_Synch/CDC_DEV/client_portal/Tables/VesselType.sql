CREATE TABLE [client_portal].[VesselType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentTypeId] [int] NULL,
	[Description] [varchar](200) NULL,
	[CreatedOnUtc] [datetime] NULL,
 CONSTRAINT [pk_VesselType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]