SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WebPostingsIndustries](
	[WebPostingsIndustriesID] [int] NOT NULL,
	[IndustryCode1] [int] NULL,
	[IndustryCode2] [int] NULL,
	[IndustryCode3] [int] NULL,
	[IndustryCode4] [int] NULL,
	[IndustryCode5] [int] NULL,
	[IndustryCode6] [int] NULL,
	[CreatedBy] [varchar](20) NULL,
	[CreatedOn] [datetime] NULL,
	[WebJobPostingsID] [int] NULL,
	[UTCCreatedOn] [smallint] NULL
 CONSTRAINT [PK_WebPostingsIndustries] PRIMARY KEY NONCLUSTERED 
(
	[WebPostingsIndustriesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[WebPostingsIndustries] ADD  CONSTRAINT [DF_WebPostingsIndustries_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[WebPostingsIndustries] ADD  CONSTRAINT [DF_WebPostingsIndustries_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[WebPostingsIndustries] ADD  DEFAULT ((1)) FOR [UTCCreatedOn]
GO

ALTER TABLE [dbo].[WebPostingsIndustries] ADD  DEFAULT ((0)) FOR [IndustryCode4]
GO

ALTER TABLE [dbo].[WebPostingsIndustries] ADD  DEFAULT ((0)) FOR [IndustryCode5]
GO

ALTER TABLE [dbo].[WebPostingsIndustries] ADD  DEFAULT ((0)) FOR [IndustryCode6]
GO

CREATE NONCLUSTERED INDEX [WebJobPostingsID] ON [dbo].[WebPostingsIndustries] 
(
	[WebJobPostingsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndustryCode1] ON [dbo].[WebPostingsIndustries] 
(
	[IndustryCode1] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IndustryCode2] ON [dbo].[WebPostingsIndustries] 
(
	[IndustryCode2] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[WebPostingsIndustries]  TO [DeskFlowUsers]
GO
IF ( select COUNT(*) from LastIDs where FieldName='WebPostingsIndustriesID')=0
INSERT INTO LastIDs ( FieldName, LastID ) Values ('WebPostingsIndustriesID',0)
GO

ALTER TRIGGER [dbo].[WebJobPostingsDelete] ON [dbo].[WebJobPostings]   
FOR DELETE   
AS  
  
delete from Questions     where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted)  
delete from SkillsQuestions where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted)  
delete from LinkWebPostingToWebSite where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted) 
delete from WebPostingsIndustries where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted) 
