ALTER TABLE JobOrders add WorkType varchar(100)
GO
ALTER TABLE JobOrders ALTER COLUMN DressCode varchar(100)
GO
CREATE TABLE [dbo].[DressCodes](
	[DressCodesID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_DressCodes] PRIMARY KEY CLUSTERED 
(
	[DressCodesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DressCodes]  TO [DeskFlowUsers]
GO
CREATE TABLE [dbo].[WorkTypes](
	[WorkTypesID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_WorkTypes] PRIMARY KEY CLUSTERED 
(
	[WorkTypesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WorkTypes]  TO [DeskFlowUsers]
GO
IF ( SELECT count(*) FROM LookupTables WHERE Name = 'DressCodes' ) = 0
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('DressCodes', 'Dress Codes', 'Description', 'Description' )
GO
IF ( SELECT count(*) FROM LookupTables WHERE Name = 'WorkTypes' ) = 0
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('WorkTypes', 'Work Types', 'Description', 'Description' )






