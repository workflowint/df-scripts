/****** Object:  Table [dbo].[ProjectsCandidateBlocks]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectsCandidateBlocks](
	[ProjectsID] [int] NOT NULL,
	[PeopleID] [int] NOT NULL,
	[WorkListsID] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_ProjectsCandidateBlocks] PRIMARY KEY CLUSTERED 
(
	[ProjectsID] ASC,
	[PeopleID] ASC,
	[WorkListsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ProjectsCandidateBlocks]  TO [DeskFlowUsers]

GO

-- Function on insert
/****** Object:  Procedure [dbo].[AddCandidateProjectBlock]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddCandidateProjectBlock] @ProjectsID int, @PeopleID int, @ListID int
AS

declare @BlockLevel int
declare @BlockDescription varchar(255)
SELECT @BlockLevel = BlockLevel, @BlockDescription = Caption
FROM Worklists WITH(NOLOCK) WHERE WorkListsID = @ListID

INSERT INTO ProjectsCandidateBlocks (ProjectsID, PeopleID, WorkListsID, CreatedOn )
VALUES (@ProjectsID, @PeopleID, @ListID, GETDATE() )

	IF ( @BlockLevel > 0 )
	BEGIN
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = @BlockDescription,
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) < @BlockLevel
    END   

GO

GRANT  EXECUTE  ON [dbo].[AddCandidateProjectBlock]  TO [DeskFlowUsers]

GO

/****** Object:  Procedure [dbo].[RemoveCandidateProjectBlock]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RemoveCandidateProjectBlock] @ProjectsID int, @PeopleID int, @ListID int
AS

	declare @BlockLevel int
	declare @BlockDescription varchar(255)	
	declare @NewProjectsID int

	-- Remove old block list
	DELETE ProjectsCandidateBlocks WHERE ProjectsCandidateBlocks.ProjectsID = @ProjectsID
										AND ProjectsCandidateBlocks.PeopleID = @PeopleID
										AND ProjectsCandidateBlocks.WorkListsID = @ListID
										
	-- Update People table block with new value
	SELECT TOP 1 @BlockLevel = C.BlockLevel, @BlockDescription = C.Caption, @NewProjectsID = C.ProjectsID FROM 
	(
		SELECT TOP 1 ProjectsCandidateBlocks.ProjectsID, ProjectsCandidateBlocks.CreatedOn, WorkLists.BlockLevel, WorkLists.Caption
		FROM ProjectsCandidateBlocks WITH(NOLOCK)
			JOIN WorkLists WITH(NOLOCK) ON ProjectsCandidateBlocks.WorkListsID = WorkLists.WorkListsID
		WHERE ProjectsCandidateBlocks.PeopleID = @PeopleID AND ProjectsCandidateBlocks.ProjectsID = @ProjectsID
		ORDER BY WorkLists.BlockLevel, WorkLists.ListNum DESC 
		
		UNION
		
		SELECT TOP 1 ProjectsCandidateBlocks.ProjectsID, ProjectsCandidateBlocks.CreatedOn, WorkLists.BlockLevel, WorkLists.Caption
		FROM ProjectsCandidateBlocks WITH(NOLOCK)
			JOIN WorkLists WITH(NOLOCK) ON ProjectsCandidateBlocks.WorkListsID = WorkLists.WorkListsID
		WHERE ProjectsCandidateBlocks.PeopleID = @PeopleID AND ProjectsCandidateBlocks.ProjectsID <> @ProjectsID
		ORDER BY  WorkLists.BlockLevel DESC, ProjectsCandidateBlocks.CreatedOn ASC, WorkLists.ListNum DESC
		
	) AS C

	IF (@BlockLevel > 0)
	BEGIN
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = @BlockDescription,
		CandidateBlockProjectsID = @ProjectsID
		WHERE People.PeopleID = @PeopleID
	END
	ELSE
	BEGIN
		UPDATE People set CandidateBlockStatus = NULL,
		BlockDescription = NULL,
		CandidateBlockProjectsID = NULL
		WHERE People.PeopleID = @PeopleID
	END
	
GO

GRANT  EXECUTE  ON [dbo].[RemoveCandidateProjectBlock]  TO [DeskFlowUsers]

GO

/****** Object:  Trigger [dbo].[ProjectsFileSearchCandidatesINSERT]    Script Date: 06/08/2015 15:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[ProjectsFileSearchCandidatesINSERT] ON [dbo].[ProjectsFileSearchCandidates] 
FOR INSERT AS
declare @PeopleID               int
declare @ProjectsID             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclFS)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclFS = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
	
		EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 1

		fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsFileSearchCandidatesOnDelete]    Script Date: 06/08/2015 15:32:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------------------------
    When a record is deleted, this deletes all records
    linked to the deleted record.
--------------------------------------------------------------------------------------------------------*/
ALTER  TRIGGER [dbo].[ProjectsFileSearchCandidatesOnDelete] ON [dbo].[ProjectsFileSearchCandidates]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

		 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclFS = NULL
		  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
		 
		 EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 1
		 
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectTargetCompaniesCandidatesINSERT]    Script Date: 06/08/2015 15:38:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectTargetCompaniesCandidatesINSERT] ON [dbo].[ProjectTargetCompaniesCandidates] 
FOR INSERT AS
declare @PeopleID               int
declare @ProjectsID             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclTC)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclTC = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
    
	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 3

	fetch next from Row into @PeopleID, @ProjectsID
END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectTargetCompaniesCandidatesOnDelete]    Script Date: 06/08/2015 15:40:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[ProjectTargetCompaniesCandidatesOnDelete] ON [dbo].[ProjectTargetCompaniesCandidates]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

		 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclTC = NULL
		  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
		 
		 EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 3
													
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close      Row
deallocate Row

GO

/****** Object:  Trigger [dbo].[ProjectsClientEmployeesListsINSERT]    Script Date: 06/08/2015 15:41:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsClientEmployeesListsINSERT] ON [dbo].[ProjectsClientEmployeesLists] 
FOR INSERT AS

declare @PeopleID               int
declare @ProjectsID             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclIR)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclIR = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
		
	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 5
	
    fetch next from Row into @PeopleID, @ProjectsID
	
    END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsClientEmployeesListsOnDelete]    Script Date: 06/08/2015 15:42:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[ProjectsClientEmployeesListsOnDelete] ON [dbo].[ProjectsClientEmployeesLists]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclIR = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
	  
	  EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 5
	  
       fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[CandidateReferralsINSERT]    Script Date: 06/08/2015 15:47:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[CandidateReferralsINSERT] ON [dbo].[CandidateReferrals] 
FOR INSERT AS
declare @PeopleID int
declare @ProjectsID             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclSR)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclSR = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
	
	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 7
	
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[CandidateReferralsOnDelete]    Script Date: 06/08/2015 15:48:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[CandidateReferralsOnDelete] ON [dbo].[CandidateReferrals]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclSR = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
	  
	  EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 7
	  
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsTargetListsINSERT]    Script Date: 06/08/2015 15:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsTargetListsINSERT] ON [dbo].[ProjectsTargetLists] 
FOR INSERT AS 

declare @PeopleID    int
declare @ProjectsID  int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclCR)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclCR = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)

		EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 8
		
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsTargetListsOnDelete]    Script Date: 06/08/2015 15:51:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[ProjectsTargetListsOnDelete] ON [dbo].[ProjectsTargetLists]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclCR = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
	  
	  	  	 EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 8
	  
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsInternalInterviewListsINSERT]    Script Date: 06/08/2015 15:53:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsInternalInterviewListsINSERT] ON [dbo].[ProjectsInternalInterviewLists] 
FOR INSERT AS
declare @PeopleID int
declare @ProjectsID int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclII)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclII = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)

		EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 9
		
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsInternalInterviewListsOnDelete]    Script Date: 06/08/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER                   TRIGGER [dbo].[ProjectsInternalInterviewListsOnDelete] ON [dbo].[ProjectsInternalInterviewLists]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @ProjectsID            	int
declare @PeopleID		int

declare Row cursor local  for
     select 
         ProjectsID, PeopleID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @ProjectsID, @PeopleID

while @@fetch_status = 0
    begin
	 delete InternalInterviews where PeopleID = @PeopleID AND ProjectsID = @ProjectsID AND Done = 0
	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclII = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
	  
		 EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 9
											
         fetch next from Row into @ProjectsID, @PeopleID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsPresentedListsINSERT]    Script Date: 06/08/2015 15:55:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsPresentedListsINSERT] ON [dbo].[ProjectsPresentedLists] 
FOR INSERT AS 
declare @PeopleID int
declare @ProjectsID int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
fetch next from Row into @PeopleID, @ProjectsID
WHILE @@fetch_status = 0
    BEGIN

	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclPR)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclPR = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
	
		EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 10
	
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsPresentedListsOnDelete]    Script Date: 06/08/2015 15:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[ProjectsPresentedListsOnDelete] ON [dbo].[ProjectsPresentedLists]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclPR = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
	  
	  		 EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 10
	  
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsShortListsINSERT]    Script Date: 06/08/2015 15:57:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsShortListsINSERT] ON [dbo].[ProjectsShortLists] 
FOR INSERT AS
---------------------------------------------------------------------------------------------------------- 
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row

fetch next from Row into @PeopleID, @ProjectsID

WHILE @@fetch_status = 0
    BEGIN
	IF NOT EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus WITH(NOLOCK) 
	WHERE ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
     BEGIN
		declare @ProjectsCallStatusID int
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT 
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclCI)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
  	 END
	ELSE 
		UPDATE ProjectsCallStatus SET InclCI = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
    
		EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 11
	
        fetch next from Row into @PeopleID, @ProjectsID
END   
close  Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[ProjectsShortListsOnDelete]    Script Date: 06/08/2015 15:58:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsShortListsOnDelete] ON [dbo].[ProjectsShortLists]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0
    begin

         delete Interview                    where PeopleID = @PeopleID AND ProjectsID = @ProjectsID 
         delete CandidateCredentials where CandidatePeopleID = @PeopleID AND ProjectsID = @ProjectsID
         delete CandidateReferences where PeopleID = @PeopleID AND ProjectsID = @ProjectsID
		 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclCI = NULL
		  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
		 
		 EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 11
		 
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row

GO

/****** Object:  Trigger [dbo].[PeopleUpdate]    Script Date: 06/08/2015 16:28:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  TRIGGER [dbo].[PeopleUpdate] ON [dbo].[People]
FOR UPDATE 
AS
if TRIGGER_NESTLEVEL() >1
return
BEGIN

UPDATE People
SET People.UpdatedBy = suser_sname(),
UpdatedOn = GETDATE()
FROM Inserted, People 
WHERE Inserted.PeopleID = People.PeopleID

UPDATE People
SET  
ExchangeRate = (SELECT CurrentRate FROM ExchangeRates WITH(NOLOCK)
WHERE CurrencyUnit = Inserted.CurrencyType),
ExchangeRateDate = GETDATE()
FROM Inserted JOIN People ON
( Inserted.PeopleID = People.PeopleID
AND ( Inserted.CurrencyType <> People.CurrencyType
OR Inserted.CustomCurrency1 <> People.CustomCurrency1
OR Inserted.CustomCurrency2 <> People.CustomCurrency2
OR Inserted.MinRate <> People.MinRate
OR Inserted.MinSalary <> People.MinSalary))

DELETE ProjectsCandidateBlocks
FROM ProjectsCandidateBlocks, inserted, deleted
WHERE ProjectsCandidateBlocks.PeopleID = deleted.PeopleID
      AND ProjectsCandidateBlocks.ProjectsID = deleted.CandidateBlockProjectsID
      AND Inserted.PeopleID = deleted.PeopleID
      AND (Inserted.PeopleID = deleted.PeopleID AND IsNull(Inserted.CandidateBlockStatus,0) = 0 AND IsNull(deleted.CandidateBlockStatus,0) > 0)

UPDATE People
SET People.CandidateBlockStatus = A.BlockLevel,
      People.CandidateBlockProjectsID = A.ProjectsID,
      People.BlockDescription = A.Caption
FROM 
(
      SELECT Inserted.PeopleId, NewBlock.BlockLevel, NewBlock.ProjectsID, NewBlock.Caption
      FROM Inserted 
            JOIN Deleted ON ( Inserted.PeopleID = Deleted.PeopleID 
                  AND IsNull(Inserted.CandidateBlockStatus,0) = 0 
                  AND IsNull(deleted.CandidateBlockStatus,0) > 0 )
            OUTER APPLY (
                  SELECT TOP 1 ProjectsCandidateBlocks.PeopleID, ProjectsCandidateBlocks.ProjectsID, ProjectsCandidateBlocks.CreatedOn, WorkLists.BlockLevel, WorkLists.Caption
                  FROM ProjectsCandidateBlocks WITH(NOLOCK)
                        JOIN WorkLists WITH(NOLOCK) ON ProjectsCandidateBlocks.WorkListsID = WorkLists.WorkListsID
                  WHERE ProjectsCandidateBlocks.PeopleID = Deleted.PeopleID AND ProjectsCandidateBlocks.ProjectsID <> Deleted.CandidateBlockProjectsID
                  AND WorkLists.BlockLevel > 0
                  ORDER BY  WorkLists.BlockLevel DESC, ProjectsCandidateBlocks.CreatedOn ASC, WorkLists.ListNum DESC
            ) AS NewBlock
) A
WHERE A.PeopleID = People.PeopleID
END
