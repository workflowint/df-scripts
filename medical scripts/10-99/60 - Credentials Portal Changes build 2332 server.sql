SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LinkWebApplicantsToCredentials](
	[LinkWebApplicantsToCredentialsID] [int] IDENTITY(1,1) NOT NULL,
	[WebApplicantsID] [int] NULL,
	[CredentialsID] [int] NULL,
	[Status] [varchar](50) NULL,
	[ExpiryDate] [datetime] NULL,
	[Notes] [text] NULL,
	[Number] [varchar](255) NULL,
	[IssueDate] [datetime] NULL,
	[Document] [image] NULL,
	[DocName] [varchar](255) NULL,
--	[FirstRequest] [datetime] NULL,
--	[SecondRequest] [datetime] NULL,
--	[ThirdRequest] [datetime] NULL,
--	[ReceivedOn] [datetime] NULL,
--	[Done] [bit] NULL,
--	[VerifiedBy] [varchar](10) NULL,
--	[VerifiedOn] [datetime] NULL,
--	[VirifiedByManager] [varchar](10) NULL,
--	[VirifiedManagerOn] [datetime] NULL,

--	[PriorExperience] [char](1) NULL,
--	[CopyOnFile] [char](1) NULL,
--	[TEMP1] [int] NULL,

--	[Cost] [money] NULL,
--	[VerifiedDetails] [varchar](255) NULL,
--	[CompaniesID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkWebApplicantsToCredentials] TO [DeskFlowUsers]

GO

CREATE TABLE [dbo].[DuplicatesCredentials] (
	[DuplicatesCredentialsID] [int] IDENTITY(1,1) NOT NULL,
	[DuplicatesID] [int] NULL,
	[CredentialsID] [int] NULL,
	[Status] [varchar](50) NULL,
	[ExpiryDate] [datetime] NULL,
	[Notes] [text] NULL,
	[Number] [varchar](255) NULL,
	[IssueDate] [datetime] NULL,
	[Document] [image] NULL,
	[DocName] [varchar](255) NULL,
--	[FirstRequest] [datetime] NULL,
--	[SecondRequest] [datetime] NULL,
--	[ThirdRequest] [datetime] NULL,
--	[ReceivedOn] [datetime] NULL,
--	[Done] [bit] NULL,
--	[VerifiedBy] [varchar](10) NULL,
--	[VerifiedOn] [datetime] NULL,
--	[VirifiedByManager] [varchar](10) NULL,
--	[VirifiedManagerOn] [datetime] NULL,

--	[PriorExperience] [char](1) NULL,
--	[CopyOnFile] [char](1) NULL,
--	[TEMP1] [int] NULL,

--	[Cost] [money] NULL,
--	[VerifiedDetails] [varchar](255) NULL,
--	[CompaniesID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DuplicatesCredentials] TO [DeskFlowUsers]
