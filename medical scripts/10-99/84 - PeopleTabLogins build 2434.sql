ALTER TABLE JobOrderSchedule add StatusDescription varchar(255)
GO
CREATE TABLE [dbo].[SitesLogins](
	SitesLoginsID [int]  NOT NULL,
	PeopleID [int] NULL,
	[Description] [varchar] (255) NULL,
	Username [varchar] (255) NULL,
	[Password] [varchar] (255) NULL,
	SiteURL [varchar] (255) NULL
 CONSTRAINT [PK_SitesLogins] PRIMARY KEY CLUSTERED 
(
	[SitesLoginsID] ASC
))
GO
CREATE TABLE [dbo].[ID_SitesLoginsID](
  [ID] [int] IDENTITY(1,1) NOT NULL,
  CONSTRAINT [PK_ID_SitesLogins] PRIMARY KEY CLUSTERED 
 ([ID] ASC) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
 )ON [PRIMARY]
GO
GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[SitesLogins] TO [DeskFlowUsers]
GO
GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[ID_SitesLoginsID] TO [DeskFlowUsers]
GO
DBCC CHECKIDENT ([ID_SitesLoginsID],reseed,0)
