IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_WebLogins_CreatedOn]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[WebLogins] DROP CONSTRAINT [DF_WebLogins_CreatedOn]
END

GO

/****** Object:  Table [dbo].[WebLogins]    Script Date: 01/17/2018 16:33:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebLogins]') AND type in (N'U'))
DROP TABLE [dbo].[WebLogins]
GO


/****** Object:  Table [dbo].[WebLogins]    Script Date: 01/17/2018 16:32:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WebLogins](
	[WebLoginsID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[LoginName] [varchar](100) NOT NULL,
	[PasswordHash] [varchar](255) NULL,
	[SessionID] [varchar](255) NULL,
	[WebToken] [varchar](255) NULL,
	[WebTokenExpires] [datetime] NULL,
	[Prefix] [varchar](15) NULL,
	[Suffix] [varchar](255) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](60) NULL,
	[Initials] [varchar](15) NULL,
	[Resume] [image] NULL,
	[ResumeDocName] [varchar](255) NULL,
	[ResumeDate] [datetime] NULL,
	[ResetCode] [varchar](20) NULL,
	[ResetCodeExpires] [datetime] NULL,
	[Email] [varchar](100) NULL,
	[AltEmail] [varchar](100) NULL,
	[Phone1] [varchar](30) NULL,
	[Phone1Type] [varchar](50) NULL,
	[Phone2] [varchar](30) NULL,
	[Phone2Type] [varchar](50) NULL,
	[JobTitle] [varchar](150) NULL,
	[CompanyName] [varchar](150) NULL,
	[City] [varchar](50) NULL,
	[Province] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
 CONSTRAINT [PK_WebLogins] PRIMARY KEY NONCLUSTERED 
(
	[WebLoginsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[WebLogins] ADD  CONSTRAINT [DF_WebLogins_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WebLogins]  TO [DeskFlowUsers]

GO

/****** Object:  Table [dbo].[WebLoginsCategories]    Script Date: 01/17/2018 16:36:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WebLoginsCategories](
	[WebLoginsCategoriesID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[WebLogin] [varchar](255) NOT NULL,
	[ProjectCategory] [varchar](255) NOT NULL,
 CONSTRAINT [PK_WebLoginsCategories] PRIMARY KEY NONCLUSTERED 
(
	[WebLoginsCategoriesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[WebLoginsCategories] ADD  CONSTRAINT [DF_WebLoginsCategories_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WebLoginsCategories]  TO [DeskFlowUsers]

GO

/****** Object:  Table [dbo].[WebLoginsPractice]    Script Date: 01/17/2018 16:37:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WebLoginsPractice](
	[WebLoginsPracticeID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[LoginName] [varchar](100) NOT NULL,
	[PracticeID] [int] NULL,
 CONSTRAINT [PK_WebLoginsPractice] PRIMARY KEY NONCLUSTERED 
(
	[WebLoginsPracticeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[WebLoginsPractice] ADD  CONSTRAINT [DF_WebLoginsPractice_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WebLoginsPractice]  TO [DeskFlowUsers]

GO

ALTER TABLE [WebLoginsSkills]
ADD IsPreference [bit] NULL

GO

ALTER TABLE [WebApplications]
ADD AHNotes [text] NULL

GO 


