CREATE TABLE [dbo].[UserExports](
	[UserExportsID] [int] IDENTITY(1,1) NOT NULL,
	[LoginName] [varchar](20) NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_UserExprts_CreatedOn]  DEFAULT (getdate()),
	[TypeOfExport] [varchar](20) NULL,
	[ExportSource] [varchar](20) NULL,
	[NumberOfRecord] [int] NULL,
	[Report] [image] NULL,
	[Import] [text] NULL,
	[RecordIDs] [text] NULL,
	[ReportID] [int] NULL,
 CONSTRAINT [PK_UserExprts] PRIMARY KEY CLUSTERED 
(
	[UserExportsID] ASC
)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [UserExportLoginName] ON [dbo].[UserExports] 
(
	[LoginName] ASC
)
GO
CREATE NONCLUSTERED INDEX [UserExportCreatedOn] ON [dbo].[UserExports] 
(
	[CreatedOn] ASC
)
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[UserExports]  TO [DeskFlowUsers]
GO
ALTER TABLE UserList add LogExports bit
GO
ALTER Table CallSheets add OpportunitiesID int 
GO 
ALTER TABLE ClientConfig add MinRecordsToAudit int
GO 
ALTER TABLE CompaniesAliases ALTER COLUMN name varchar(100)
GO
ALTER TABLE Document ALTER COLUMN name varchar(255)
GO
ALTER TABLE Document ALTER COLUMN Abstract varchar(255)
