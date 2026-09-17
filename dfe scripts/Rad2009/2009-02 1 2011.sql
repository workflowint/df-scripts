ALTER TABLE LinkOpportunitiesToBusinessObjects add ObjectName varchar(20)
go
UPDATE LinkOpportunitiesToBusinessObjects set ObjectName='Opportunities'
GO
ALTER TABLE CandidateCredentials ALTER COLUMN Notes text
GO
CREATE TABLE [dbo].[ReportsAssignedToButtons](
	[ReportsAssignedToButtonsID] [int] IDENTITY(1,1) NOT NULL,
	[FormName] [varchar](50) NULL,
	[ButtonName] [varchar](50) NULL,
	[ReportsID] [int] NULL)
go
ALTER TABLE [dbo].[ReportsAssignedToButtons] WITH NOCHECK ADD 
	CONSTRAINT [PK_ReportsAssignedToButtonsID] PRIMARY KEY  CLUSTERED 
	(
		[ReportsAssignedToButtonsID]
	)  ON [PRIMARY] 
GO
CREATE NONCLUSTERED INDEX [FormName_Index1] ON [dbo].[ReportsAssignedToButtons] 
(
	[FormName] ASC
)
go
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ReportsAssignedToButtons]  TO [DeskFlowUsers]
GO
IF ( SELECT COUNT(*) FROM DataCashTables WHERE Name='ReportsAssignedToButtons' )=0
INSERT INTO DataCashTables ( Name,UpdatedOn) VALUES('ReportsAssignedToButtons',getdate())

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportsAssignedToButtonsTrigger]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ReportsAssignedToButtonsTrigger]
GO
CREATE TRIGGER ReportsAssignedToButtonsTrigger ON [dbo].[ReportsAssignedToButtons] 
FOR INSERT, UPDATE, DELETE 
AS

UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='ReportsAssignedToButtons'
GO
ALTER TABLE ClientConfig add SCRText text
GO
ALTER TABLE dbo.LinkOpportunitiesToBusinessObjects ADD
	ObjectName varchar(100) NULL
GO
ALTER TABLE dbo.LinkOpportunitiesToBusinessObjects ADD
	JobOrdersID int NULL
GO
ALTER TABLE dbo.SearchContactRecord ADD
	JobOrdersID int NULL
GO
ALTER TABLE ActivityTypes add UseInBPL bit
go
UPDATE ActivityTypes set UseInBPL =0
go
UPDATE ActivityTypes set UseInBPL =1 where TypeName like 'Marketing Activ%'
GO
ALTER TABLE [dbo].[ProfileImporterPeople]
ADD [Photo] [image] NULL
GO
ALTER TABLE JobOrderPresentedPeople add PayRate money, BillRate money
GO
ALTER TABLE dbo.People ADD
	SkypePhone varchar(255) NULL
GO

CREATE TABLE [dbo].[RegionCoverage] (
	[RegionCoverageID] [int] IDENTITY (1, 1) NOT NULL ,
	[ProjectsID] [int] NULL ,
	[JobOrdersID] [int] NULL ,
	[RegionCode1] [int] NULL ,
	[RegionCode2] [int] NULL ,
	[RegionCode3] [int] NULL ,
	[CreatedOn] [datetime] NULL ,
	[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RegionCoverage] WITH NOCHECK ADD 
	CONSTRAINT [PK_RegionCoverage] PRIMARY KEY  CLUSTERED 
	(
		[RegionCoverageID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RegionCoverage] ADD 
	CONSTRAINT [DF_RegionCoverage_CreatedOn] DEFAULT (getdate()) FOR [CreatedOn],
	CONSTRAINT [DF_RegionCoverage_CreatedBy] DEFAULT (suser_sname()) FOR [CreatedBy]
GO

 CREATE  INDEX [IX_RegionCoverage] ON [dbo].[RegionCoverage]([ProjectsID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_RegionCoverage_1] ON [dbo].[RegionCoverage]([JobOrdersID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_RegionCoverage_2] ON [dbo].[RegionCoverage]([RegionCode1], [RegionCode2], [RegionCode3]) ON [PRIMARY]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[RegionCoverage]  TO [DeskFlowUsers]
GO

ALTER TABLE dbo.ProjectsCallStatus ADD
	InclFS bit NULL,
	InclBM bit NULL,
	InclTC bit NULL,
	InclAR bit NULL,
	InclIR bit NULL,
	InclSO bit NULL,
	InclSR bit NULL,
	InclCR bit NULL,
	InclII bit NULL,
	InclPR bit NULL,
	InclCI bit NULL,
	InclPL bit NULL
GO

CREATE TABLE [dbo].[WorkLists] (
	[WorkListsID] [int] IDENTITY (1, 1) NOT NULL ,
	[ListName] [varchar] (255) NULL ,
	[ListAbbrev] [varchar] (10) NULL ,
	[ListNum] [int] NULL ,
	[ListInUse] [bit] NULL 
) ON [PRIMARY]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WorkLists]  TO [DeskFlowUsers]
GO

ALTER TABLE Task ALTER COLUMN Warning int
GO
ALTER TABLE TaskData ALTER COLUMN Warning int
GO
ALTER TABLE ActivityTypes add UseInSCR bit
GO
UPDATE ActivityTypes set  UseInSCR =0



