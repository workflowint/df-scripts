SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ApplicantAlerts](
	[ApplicantAlertsID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[PeopleID] [int] NULL,
	[ProjectsID] [int] NULL,
	[ResumeID] [int] NULL,
	[DocumentIDList] [varchar](max) NULL,
	[UTCCreatedOn] [smallint] NULL,

 CONSTRAINT [PK_ApplicantAlertsID] PRIMARY KEY NONCLUSTERED 
(
	[ApplicantAlertsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ApplicantAlerts] ADD  CONSTRAINT [DF_ApplicantAlerts_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[ApplicantAlerts] ADD  CONSTRAINT [DF_ApplicantAlerts_Owner]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[ApplicantAlerts] ADD  DEFAULT ((1)) FOR [UTCCreatedOn]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ApplicantAlerts] TO [DeskFlowUsers]

GO

ALTER TABLE [dbo].[UserList]
ADD [ReceiveApplicantAlerts] [bit] NOT NULL DEFAULT(0)

GO