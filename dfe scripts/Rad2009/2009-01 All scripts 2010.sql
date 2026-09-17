ALTER TABLE GlobalEMailSettings add CopyToOutlookTasks bit NULL
GO
ALTER TABLE Taskdata DISABLE TRIGGER TaskDataUpdate
UPDATE TaskData set OutlookID =NULL FROM Task,TaskData
where Task.TaskID = TaskData.TaskID 
and OutlookID='' and Task.Type in (2,3)
ALTER TABLE TaskData ENABLE TRIGGER TaskDataUpdate
GO
CREATE TABLE [dbo].[LanguageDictionaries] (
	[LanguageDictionariesID] [int] IDENTITY (1, 1) NOT NULL ,
	[LangFileName] [varchar] (255) NULL ,
	[FileDateTime] [datetime] NULL ,
	[CreatedOn] [datetime] NULL ,
	[CreatedBy] [varchar] (50) NULL ,
	[FileData] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[LanguageDictionaries] ADD 
	CONSTRAINT [DF_LanguageDictionaries_CreatedOn] DEFAULT (getdate()) FOR [CreatedOn]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LanguageDictionaries]  TO [DeskFlowUsers]
GO
ALTER TABLE dbo.People ADD
	Photo image NULL
GO
ALTER TABLE ClientConfig add ExtraFieldsOnContractPlacement bit null
GO
UPDATE ClientConfig set ExtraFieldsOnContractPlacement=1
GO
IF (select count(*) from LookupTables where name = 'InvoiceDetailsTypes' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('InvoiceDetailsTypes','Invoice Item Type','Description','Name,Description')
GO
Update LookupTables set CanDelete = 1
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CustomFormData]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CustomFormData]
GO

CREATE TABLE [dbo].[CustomFormData] (
	[CustomFormDataID] [int] IDENTITY (1, 1) NOT NULL ,
	[FormClassName] [varchar] (255) NULL ,
	[CreatedOn] [datetime] NULL ,
	[CreatedBy] [varchar] (20) NULL ,
	[UpdatedOn] [datetime] NULL ,
	[UpdatedBy] [varchar] (20) NULL ,
	[FormData] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomFormData] WITH NOCHECK ADD 
	CONSTRAINT [PK_CustomFormData] PRIMARY KEY  CLUSTERED 
	(
		[CustomFormDataID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CustomFormData] ADD 
	CONSTRAINT [DF_CustomFormData_CreatedOn] DEFAULT (getdate()) FOR [CreatedOn],
	CONSTRAINT [DF_CustomFormData_CreatedBy] DEFAULT (suser_sname()) FOR [CreatedBy],
	CONSTRAINT [DF_CustomFormData_UpdatedOn] DEFAULT (getdate()) FOR [UpdatedOn],
	CONSTRAINT [DF_CustomFormData_UpdatedBy] DEFAULT (suser_sname()) FOR [UpdatedBy]
GO

 CREATE  INDEX [IX_CustomFormData] ON [dbo].[CustomFormData]([FormClassName]) ON [PRIMARY]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CustomFormData]  TO [DeskFlowUsers]
GO

DELETE FROM DataCashTables
WHERE Name IN ( 'HiddenControls', 'CustomLabels')

CREATE TABLE [dbo].[ControlAccessData] (
	[FormClassName] [varchar] (255) NOT NULL ,
	[ControlName] [varchar] (255) NOT NULL ,
	[ReadOnlyForGroups] [varchar] (255) NULL ,
	[HiddenForGroups] [varchar] (255) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ControlAccessData] WITH NOCHECK ADD 
	CONSTRAINT [PK_ControlAccessData] PRIMARY KEY  CLUSTERED 
	(
		[FormClassName],
		[ControlName]
	)  ON [PRIMARY] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ControlAccessData]  TO [DeskFlowUsers]
GO

CREATE TABLE [dbo].[ComponentsData] (
	[ComponentName] [varchar] (255) NOT NULL ,
	[ComponentData] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ComponentsData] WITH NOCHECK ADD 
	CONSTRAINT [PK_ComponentsData] PRIMARY KEY  CLUSTERED 
	(
		[ComponentName]
	)  ON [PRIMARY] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ComponentsData]  TO [DeskFlowUsers]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[HiddenControls]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[HiddenControls]
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CustomLabels]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CustomLabels]
GO

ALTER TABLE ProjectsFileSearchCandidates add Rank2 varchar(10)
go
ALTER TABLE ProjectsBenchmarkCandidates add Rank2 varchar(10)
go
ALTER TABLE ProjectsClientEmployeesLists add Rank2 varchar(10)
go
ALTER TABLE ProjectTargetCompaniesCandidates add Rank2 varchar(10)
go
ALTER TABLE PeopleAppliedTo add Rank2 varchar(10)
go
ALTER TABLE ProjectsTargetLists add Rank2 varchar(10)
go
ALTER TABLE ProjectsShortLists add Rank2 varchar(10)
go
ALTER TABLE ProjectsPresentedLists add Rank2 varchar(10)
go
ALTER TABLE ProjectsInternalInterviewLists add Rank2 varchar(10)
go
ALTER TABLE CandidateReferrals add Rank2 varchar(10)
go
ALTER TABLE ProjectsCallStatus add StatusDescription varchar(50)
GO
CREATE TABLE [dbo].[CallStatusDescription](
	[CallStatusDescriptionID] [int] IDENTITY(1,1) NOT NULL,
	[CallStatusDescription] [varchar](50) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CallStatusDescription] WITH NOCHECK ADD 
	CONSTRAINT [PK_CallStatuses] PRIMARY KEY  CLUSTERED 
	(
		[CallStatusDescriptionID]
	)  ON [PRIMARY] 
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CallStatusDescription]  TO [DeskFlowUsers]
GO
IF (select count(*) from LookupTables where name = 'CallStatusDescription' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('CallStatusDescription','Call Status Description','CallStatusDescription','CallStatusDescription')
GO
ALTER TABLE MarketingCallReport add IsUTCTime smallint, TaskID int   
GO
ALTER TABLE dbo.LinkContactsToOpportunities ADD
	Rank2 varchar(50) NULL
GO



