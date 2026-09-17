ALTER TABLE Resumes add ImportedOn datetime default ( getdate())
GO
ALTER TABLE Duplicates add FileName varchar(255)
GO
select * into OpportunityTeams_Backup from OpportunityTeams
go
if ( select count(*) from LastIDs where FieldName='OpportunityTeamsID' ) = 0
begin
 INSERT INTO LastIDs (FieldName, LastID) VALUES ('OpportunityTeamsID', (IDENT_CURRENT('OpportunityTeams') + 100) )
 drop table OpportunityTeams
 CREATE TABLE [dbo].[OpportunityTeams](
	[OpportunityTeamsID] [int] NOT NULL,
	[UserLogin] [nvarchar](50) NULL,
	[OpportunitiesID] [int] NOT NULL,
	[TeamRoleID] [int] NULL,
	[CreatedOn] [smalldatetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [smalldatetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[Comments] [nvarchar](255) NULL,
	[SinceDate] [smalldatetime] NULL,
 CONSTRAINT [PK_OpportunityTeams] PRIMARY KEY CLUSTERED 
(
	[OpportunityTeamsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
end
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[OpportunityTeams]  TO [DeskFlowUsers]
GO
ALTER TABLE [dbo].[OpportunityTeams] ADD  CONSTRAINT [DF_OpportunityTeams_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[OpportunityTeams] ADD  CONSTRAINT [DF_OpportunityTeams_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[OpportunityTeams] ADD  CONSTRAINT [DF_OpportunityTeams_UpdatedOn]  DEFAULT (getdate()) FOR [UpdatedOn]
GO

ALTER TABLE [dbo].[OpportunityTeams] ADD  CONSTRAINT [DF_OpportunityTeams_UpdatedBy]  DEFAULT (suser_sname()) FOR [UpdatedBy]
GO
if ( select COUNT(*) from OpportunityTeams) =  0
	insert into OpportunityTeams select * from OpportunityTeams_Backup