CREATE TABLE [dbo].[ObjectOrigin] (
	[ObjectOriginID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectOrigin] WITH NOCHECK ADD 
	CONSTRAINT [PK_ObjectOrigin] PRIMARY KEY  CLUSTERED 
	(
		[ObjectOriginID]
	)  ON [PRIMARY] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ObjectOrigin]  TO [DeskFlowUsers]
GO

IF (select count(*) from LookupTables where name = 'ObjectOrigin' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('ObjectOrigin','Origination of business object - Project, Job Orders, etc.','Description','Description')
GO

ALTER TABLE dbo.Projects ADD
	Origin varchar(100) NULL
GO

ALTER TABLE dbo.JobOrders ADD
	Origin varchar(100) NULL
GO

ALTER TABLE dbo.Assignments ADD
	Origin varchar(100) NULL
GO
