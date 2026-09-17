/****** Object:  Table [dbo].[PVAType]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PVAType](
	[PVATypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_PVAType] PRIMARY KEY CLUSTERED 
(
	[PVATypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PVAType]  TO [DeskFlowUsers]

GO

IF NOT EXISTS(SELECT Name FROM LookupTables WHERE Name = 'PVAType')
BEGIN
	INSERT INTO LookupTables (Name, Description, Editable, Visible)
	VALUES ('PVAType', 'PVA Types for Companies', 'Description', 'Description' )
END

GO

/****** Object:  Table [dbo].[LinkCompaniesToPVA]    Script Date: 09/24/2014 15:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LinkCompaniesToPVA](
	[CompaniesID] [int] NOT NULL,
	[PVATypeID] [int] NOT NULL,
	[MemberID] [varchar](255) NOT NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_LinkCompaniesToPVA_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [varchar](20) NULL CONSTRAINT [DF_LinkCompaniesToPVA_CreatedBy]  DEFAULT (suser_sname()),
	[Status] [varchar](20) NULL,
	[MembershipDate] [datetime] NULL,
	[InactiveDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy]	[varchar](20) NULL,
	[LicenseID] [varchar](255) NULL,
	[Comments] [text] NULL,
 CONSTRAINT [PK_LinkCompaniesToPVA] PRIMARY KEY CLUSTERED 
(
	[CompaniesID] ASC,
	[PVATypeID] ASC,
	[MemberID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkCompaniesToPVA]  TO [DeskFlowUsers]

GO