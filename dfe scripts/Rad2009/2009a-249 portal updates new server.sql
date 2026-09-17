ALTER TABLE DuplicatesSkills
ADD SkillCategoryID int NULL

GO

ALTER TABLE LinkWebApplicantsToSkills
ADD SkillCategoryID int NULL

GO

ALTER TABLE Duplicates
ADD LoginName [varchar](100) NULL,
	AltEmailAddress [varchar](100) NULL

GO

ALTER TABLE WebApplications
ADD AltEmailAddress [varchar](100) NULL

GO

/****** Object:  Table [dbo].[WebLogins]    Script Date: 11/22/2017 19:04:28 ******/
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
	[ResetCode] [varchar](20) NULL,
	[ResetCodeExpires] [datetime] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](60) NULL,
	[Initials] [varchar](15) NULL,
	[Resume] [image] NULL,
	[ResumeDocName] [varchar](255) NULL,
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

/****** Object:  Table [dbo].[WebLoginsSkills]    Script Date: 11/22/2017 19:04:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WebLoginsSkills](
	[WebLoginsSkillsID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[LoginName] [varchar](100) NOT NULL,
	[SkillsID]	[int] NULL,
	[SkillCategoryID] [int] NULL,
	[IntValue] [int] NULL,
	[SkillsLevelsID] [int] NULL,
 CONSTRAINT [PK_WebLoginsSkills] PRIMARY KEY NONCLUSTERED 
(
	[WebLoginsSkillsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[WebLoginsSkills] ADD  CONSTRAINT [DF_WebLoginsSkills_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WebLoginsSkills]  TO [DeskFlowUsers]

