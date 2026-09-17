ALTER TABLE GroupPermissions add SaveEmailInDB bit
go
UPDATE GroupPermissions set SaveEmailInDB = 1
GO
ALTER TABLE UserLastTouch add TemplateSubjectForProject varchar(255)
GO 
ALTER TABLE EMailAddress add AddressInValid bit
GO
ALTER TABLE People add Phone1IsInvalid bit
GO

ALTER   TRIGGER [dbo].[PositionsDelete] ON [dbo].[Positions]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PositionsID        int
declare @ProjectsID         int
declare @JobOrdersID        int
declare @PeopleID			int

declare Row cursor local  for
     select  PositionsID, PeopleID, ProjectsID, JobOrdersID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PositionsID, @PeopleID, @ProjectsID, @JobOrdersID

while @@fetch_status = 0
    begin

        delete from PositionDetails             	where PositionsID =  @PositionsID
        delete from LinkPositionsToRates             	where PositionsID =  @PositionsID
        delete from LinkJobOrderScheduleToPosition      where PositionsID =  @PositionsID
        delete from LinkJobOrderToWorksteps      where PositionsID =  @PositionsID
		update Task SET PositionsID = NULL 	where PositionsID =  @PositionsID
		delete from TimeSheets 			where PositionsID =  @PositionsID
		delete from PositionExpenses    	where PositionsID =  @PositionsID
		UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclPL = NULL
			WHERE ( ProjectsCallStatus.PeopleID = @PeopleID 
			AND ProjectsCallStatus.ProjectsID = @ProjectsID AND @ProjectsID > 0)	

         fetch next from Row into @PositionsID, @PeopleID, @ProjectsID, @JobOrdersID

    end
          
close            Row
deallocate  Row
GO
DELETE FROM ProgramComponents
WHERE Name LIKE 'Fast Track Assignments'
GO
IF NOT EXISTS( SELECT ProgramComponentsID FROM ProgramComponents WITH(NOLOCK)
WHERE Name LIKE 'Temps Assignments')
INSERT INTO ProgramComponents( Name ) VALUES( 'Temps Assignments' )
GO

ALTER TABLE dbo.UserLastTouch ADD
	OpenFTAssignments tinyint NULL
GO
ALTER TABLE dbo.Assignments ADD
	AddressesID2 int NULL,
	AssignmentDate datetime NULL,
	Owner1 varchar(20) NULL,
	Owner2 varchar(20) NULL,
	ResponsibilitiesID1 int NULL,
	ResponsibilitiesID2 int NULL,
	ResponsibilitiesID3 int NULL,
	Office varchar(50) NULL,
	Location2 varchar(255) NULL,
	RefNumber varchar(255) NULL,
	Category varchar(200) NULL,
	PlacementComments text NULL,
	LockedUntilDate datetime NULL,
	LockStatus varchar(100) NULL,
	PreferredPeopleID int NULL,
	ReportedHours float(53) NULL,
	PlacementStatus varchar(100) NULL
GO
ALTER TABLE dbo.GroupPermissions ADD
	FTAssignment_Edit bit NULL,
	FTAssignment_Delete bit NULL,
	FTAssignment_CreateNew bit NULL,
	FTAssignment_Placement bit NULL,
	FTAssignment_Locking bit NULL
GO
ALTER TABLE Projects add SCROriginalText text
GO
CREATE TABLE [dbo].[ResumeType](
	[ResumeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) 
)ON [PRIMARY]
GO
ALTER TABLE Resumes add Type varchar(50)
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ResumeType]  TO [DeskFlowUsers]
GO
IF (select count(*) from LookupTables where name = 'ResumeType' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('ResumeType','Resume Type','Description','Description')
GO
UPDATE LookupTables
SET Editable = 'JobTitle,JobType',
Visible = 'JobTitle, JobType'
WHERE Name LIKE 'Titles'
GO
