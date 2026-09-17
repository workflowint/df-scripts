ALTER TABLE Education
ADD [VerifiedDetails] [varchar](255) NULL

ALTER TABLE LinkPeopleToCredentials
ADD [VerifiedDetails] [varchar](255) NULL

ALTER TABLE Positions
ADD [VerifiedOn] [datetime] NULL,
	[VerifiedBy] [varchar](20) NULL,
	[VerifiedDetails] [varchar](255) NULL

GO
/****** Object:  Table [dbo].[VerifiedDetailsLookup]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VerifiedDetailsLookup](
	[VerifiedDetailsLookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_VerifiedDetailsLookup] PRIMARY KEY CLUSTERED 
(
	[VerifiedDetailsLookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[VerifiedDetailsLookup]  TO [DeskFlowUsers]

GO

IF NOT EXISTS(SELECT Name FROM LookupTables WHERE Name = 'VerifiedDetailsLookup')
BEGIN
	INSERT INTO LookupTables (Name, Description, Editable, Visible)
	VALUES ('VerifiedDetailsLookup', 'Verified By Details in PEOPLE', 'Description', 'Description' )
END

GO