/****** Object:  Table [dbo].[ApplicantMessages]    Script Date: 2021-04-13 2:38:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.ApplicantMessages', 'U') IS NOT NULL
	DROP TABLE [dbo].[ApplicantMessages];

GO

CREATE TABLE [dbo].[ApplicantMessages](
	[ApplicantMessagesID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[PeopleID] [int] NULL,
	[EmailAddress] [varchar](100) NULL,
	[ProjectsID] [int] NULL,
	[JobOrdersID] [int] NULL,
	[ResumeID] [int] NULL,
	[DocumentIDList] [varchar](max) NULL,
	[TemplateID] [int] NULL,
	[MessageBody] [varchar](max) NULL,
	[Subject] [varchar](255) NULL,
	[EmailFormat] [int] NULL,
	[RetryCount] [int] NULL,
	[LastError] [varchar](max) NULL,
	[UTCCreatedOn] [smallint] NULL,
 CONSTRAINT [PK_ApplicantMessagesID] PRIMARY KEY NONCLUSTERED 
(
	[ApplicantMessagesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ApplicantMessages] ADD  CONSTRAINT [DF_ApplicantMessages_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[ApplicantMessages] ADD  CONSTRAINT [DF_ApplicantMessages_Owner]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[ApplicantMessages] ADD  DEFAULT ((1)) FOR [UTCCreatedOn]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ApplicantMessages] TO [DeskFlowUsers]

GO

ALTER TABLE ApplicantAlerts
ADD RetryCount int NULL, LastError varchar(max) NULL
