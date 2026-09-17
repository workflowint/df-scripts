CREATE TABLE [dbo].[LinkInterviewersToIntInterview](
	[LinkInterviewersToIntInterviewID] [int] IDENTITY(1,1) NOT NULL,
	[InterviewID] [int] NULL,
	[UserLogin] [varchar](20) NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedOn] [datetime] NULL,
	[UTCCreatedOn] [smallint] NULL,
 CONSTRAINT [PK_LinkInterviewersToIntInterview] PRIMARY KEY CLUSTERED 
(
	[LinkInterviewersToIntInterviewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[LinkInterviewersToIntInterview] ADD  CONSTRAINT [LinkIntToIntInterview_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[LinkInterviewersToIntInterview] ADD  CONSTRAINT [LinkIntToIntInterview_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[LinkInterviewersToIntInterview] ADD  CONSTRAINT [LinkIntToIntInterview_UTCCreatedOn]  DEFAULT ((1)) FOR [UTCCreatedOn]
GO
CREATE NONCLUSTERED INDEX [InterviewID_LinkIntToIntInterview] ON [dbo].[LinkInterviewersToIntInterview] 
(
	[InterviewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IntID_Log_LinkIntToIntInterview] ON [dbo].[LinkInterviewersToIntInterview] 
(
	[InterviewID] ASC,
	[UserLogin] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkInterviewersToIntInterview]  TO [DeskFlowUsers]
