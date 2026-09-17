update LookupTables set Visible='Name,Description' where Name='ProjectInvoiceTypes'
GO
ALTER TABLE ProjectStages add StageGrade varchar(50), StageNotes text
GO
IF (select count(*) from LookupTables where name = 'SkillsMeasurement' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('SkillsMeasurement','Skills Measurement','SkillsMeasurementID,Name','Name')
GO
CREATE TABLE [dbo].[ProjectStageGrade](
	[ProjectStageGradeID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectStageGrade] [varchar](50) NULL,
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectStageGrade] WITH NOCHECK ADD 
	CONSTRAINT [PK_ProjectStageGrade] PRIMARY KEY  CLUSTERED 
	(
		[ProjectStageGradeID]
	)  ON [PRIMARY] 
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ProjectStageGrade]  TO [DeskFlowUsers]
GO
IF ( select count(*) from LookupTables where Name ='ProjectStageGrade')=0
INSERT INTO LookupTables (Name,Description,Editable,Visible)
VALUES ('ProjectStageGrade','Project Stage Grade','ProjectStageGrade','ProjectStageGrade')
GO
CREATE TABLE [dbo].[LinkSkillsToInternalInterview](
	[LinkSkillsToInternalInterviewID] [int] IDENTITY(1,1) NOT NULL,
	[SkillsID] [int] NULL,
	[CategoryID] [int] NULL,
	[InternalInterviewsID] [int] NOT NULL,
	[Notes] [text] NULL,
	[DisplayName] [varchar](255) NULL,
	[SkillsLevelsID] [int] NULL,
) ON [PRIMARY] 

GO
ALTER TABLE [dbo].[LinkSkillsToInternalInterview] WITH NOCHECK ADD 
	CONSTRAINT [PK_LinkSkillsToInternalInterview] PRIMARY KEY  CLUSTERED 
	(
		[LinkSkillsToInternalInterviewID]
	)  ON [PRIMARY] 
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkSkillsToInternalInterview]  TO [DeskFlowUsers]
GO
ALTER TRIGGER [dbo].[InternalInterviewsDelete] ON [dbo].[InternalInterviews]
FOR  DELETE 
AS
-----------------------------------------------------------------------------------------------------------
declare @TaskID int
declare @IntIntID int

declare Row cursor local for
     select 
         TaskID, InternalInterviewsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @TaskID, @IntIntID

while @@fetch_status = 0
    begin

         delete Task where TaskID =  @TaskID and CallCode is null
		 delete from LinkInternalInterviewsToResults where InternalInterviewsID = @IntIntID 
		 delete from LinkSkillsToInternalInterview where InternalInterviewsID = @IntIntID 
         fetch next from Row into @TaskID, @IntIntID

    end
          
close          Row
deallocate  Row


