ALTER TABLE Notes ALTER COLUMN Description varchar(255)
GO
if ( select COUNT(*) from LastIDs where FieldName='SkillsMeasurementID')=0
insert INTO LastIDs (FieldName,LastID) 
select 'SkillsMeasurementID',IsNull(MAX(SkillsMeasurementID),0) from SkillsMeasurement
GO
if ( select COUNT(*) from LastIDs where FieldName='SkillsLevelsID')=0
insert INTO LastIDs (FieldName,LastID) 
select 'SkillsLevelsID',IsNull(MAX(SkillsLevelsID),0) from SkillsLevels
GO
ALTER TABLE ProjectsCallStatus add OpportunitiesID int
GO
ALTER TABLE UserLastTouch add OpenOpportunity tinyint, OpenMyOpportunity tinyint
GO
CREATE TABLE [dbo].[UserProjectsRanks](
	[ProjectsID] [int] NOT NULL,
	[UserName] [varchar](20) NOT NULL,
	[UserRank] [varchar](50) NULL,
 CONSTRAINT [PK_UserProjectsRanks] PRIMARY KEY CLUSTERED 
(
	[ProjectsID] ASC,
	[UserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [UserProjectsRank_ProjectsID] ON [dbo].[UserProjectsRanks] 
(
	[ProjectsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UserProjectsRank_UserName] ON [dbo].[UserProjectsRanks] 
(
	[UserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[UserProjectsRanks]  TO [DeskFlowUsers]
GO
