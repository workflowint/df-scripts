/****** Object:  Trigger [dbo].[ProjectsShortListsOnDelete]    Script Date: 05/19/2011 12:36:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------------------------
    When a record is deleted, this deletes all records
    linked to the deleted record.
--------------------------------------------------------------------------------------------------------*/
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

         delete Interview                    where PeopleID = @PeopleID AND ProjectsID = @ProjectsID AND Done = 0
         delete CandidateCredentials where CandidatePeopleID = @PeopleID AND ProjectsID = @ProjectsID
         delete CandidateReferences where PeopleID = @PeopleID AND ProjectsID = @ProjectsID
		 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclCI = NULL
		  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO

/****** Object:  Trigger [ProjectsFileSearchCandidatesINSERT]    Script Date: 05/20/2011 11:07:33 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsFileSearchCandidatesINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsFileSearchCandidatesINSERT]
GO
/****** Object:  Trigger [dbo].[ProjectsFileSearchCandidatesINSERT]    Script Date: 05/19/2011 14:21:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsFileSearchCandidatesINSERT] ON [dbo].[ProjectsFileSearchCandidates] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

/****** Object:  Trigger [ProjectsFileSearchCandidatesOnDelete]    Script Date: 05/20/2011 11:09:52 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsFileSearchCandidatesOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsFileSearchCandidatesOnDelete]

GO

/****** Object:  Trigger [dbo].[ProjectsFileSearchCandidatesOnDelete]    Script Date: 05/19/2011 14:23:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------------------------
    When a record is deleted, this deletes all records
    linked to the deleted record.
--------------------------------------------------------------------------------------------------------*/
CREATE  TRIGGER [dbo].[ProjectsFileSearchCandidatesOnDelete] ON [dbo].[ProjectsFileSearchCandidates]
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
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO
/****** Object:  Trigger [ProjectsBenchmarkCandidatesOnDelete]    Script Date: 05/20/2011 11:11:13 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsBenchmarkCandidatesOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsBenchmarkCandidatesOnDelete]
GO


/****** Object:  Trigger [ProjectsBenchmarkCandidatesINSERT]    Script Date: 05/20/2011 11:10:43 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsBenchmarkCandidatesINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsBenchmarkCandidatesINSERT]

GO
/****** Object:  Trigger [dbo].[ProjectsBenchmarkCandidatesINSERT]    Script Date: 05/19/2011 14:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsBenchmarkCandidatesINSERT] ON [dbo].[ProjectsBenchmarkCandidates] 
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
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclBM)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclBM = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

/****** Object:  Trigger [dbo].[ProjectsBenchmarkCandidatesOnDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[ProjectsBenchmarkCandidatesOnDelete] ON [dbo].[ProjectsBenchmarkCandidates]
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

		 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclBM = NULL
		  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO
------------------
/****** Object:  Trigger [ProjectTargetCompaniesCandidatesOnDelete]    Script Date: 05/20/2011 11:12:27 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectTargetCompaniesCandidatesOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectTargetCompaniesCandidatesOnDelete]
GO

/****** Object:  Trigger [dbo].[ProjectTargetCompaniesCandidatesDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[ProjectTargetCompaniesCandidatesOnDelete] ON [dbo].[ProjectTargetCompaniesCandidates]
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
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close      Row
deallocate Row
GO
------------- ================================= -----------------
/****** Object:  Trigger [ProjectTargetCompaniesCandidatesINSERT]    Script Date: 05/20/2011 11:11:59 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectTargetCompaniesCandidatesINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectTargetCompaniesCandidatesINSERT]

GO

/****** Object:  Trigger [dbo].[ProjectTargetCompaniesCandidatesINSERT]    Script Date: 05/19/2011 14:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectTargetCompaniesCandidatesINSERT] ON [dbo].[ProjectTargetCompaniesCandidates] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

------------- ========================= ----------------------
/****** Object:  Trigger [PeopleAppliedToOnDelete]    Script Date: 05/20/2011 11:26:49 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PeopleAppliedToOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[PeopleAppliedToOnDelete]

GO

/****** Object:  Trigger [dbo].[PeopleAppliedToDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[PeopleAppliedToOnDelete] ON [dbo].[PeopleAppliedTo]
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

	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclAR = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO
-----------------------=======================================---------------------------
/****** Object:  Trigger [ProjectsClientEmployeesListsINSERT]    Script Date: 05/20/2011 11:32:01 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsClientEmployeesListsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsClientEmployeesListsINSERT]
GO

/****** Object:  Trigger [dbo].[ProjectsClientEmployeesListsINSERT]    Script Date: 05/19/2011 14:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsClientEmployeesListsINSERT] ON [dbo].[ProjectsClientEmployeesLists] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

---------=======================================--------------------------------------
/****** Object:  Trigger [ProjectsClientEmployeesListsOnDelete]    Script Date: 05/20/2011 11:32:28 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsClientEmployeesListsOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsClientEmployeesListsOnDelete]
GO
/****** Object:  Trigger [dbo].[ProjectsClientEmployeesListsDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[ProjectsClientEmployeesListsOnDelete] ON [dbo].[ProjectsClientEmployeesLists]
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
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO
--------===================================---------------------------------
/****** Object:  Trigger [CandidateReferralsINSERT]    Script Date: 05/20/2011 11:33:30 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CandidateReferralsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[CandidateReferralsINSERT]
GO
/****** Object:  Trigger [dbo].[CandidateReferralsINSERT]    Script Date: 05/19/2011 14:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[CandidateReferralsINSERT] ON [dbo].[CandidateReferrals] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO
---------------------====================================----------------------
/****** Object:  Trigger [CandidateReferralsOnDelete]    Script Date: 05/20/2011 11:34:01 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CandidateReferralsOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[CandidateReferralsOnDelete]
GO
/****** Object:  Trigger [dbo].[CandidateReferralsDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[CandidateReferralsOnDelete] ON [dbo].[CandidateReferrals]
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
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO
----------------------===================================-------------------------------------

/****** Object:  Trigger [dbo].[ProjectsInternalInterviewListsOnDelete]    Script Date: 05/19/2011 15:04:47 ******/
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
         fetch next from Row into @ProjectsID, @PeopleID

    end
          
close            Row
deallocate  Row
GO
--------------------- ============================= ----------------------------
/****** Object:  Trigger [ProjectsInternalInterviewListsINSERT]    Script Date: 05/20/2011 11:35:47 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsInternalInterviewListsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsInternalInterviewListsINSERT]
GO
/****** Object:  Trigger [dbo].[ProjectsInternalInterviewListsINSERT]    Script Date: 05/19/2011 14:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsInternalInterviewListsINSERT] ON [dbo].[ProjectsInternalInterviewLists] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

---------------- ================================ ------------------------------
/****** Object:  Trigger [ProjectsSourcesOnDelete]    Script Date: 05/20/2011 11:36:17 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsSourcesOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsSourcesOnDelete]
GO

/****** Object:  Trigger [dbo].[ProjectsSourcesDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[ProjectsSourcesOnDelete] ON [dbo].[ProjectsSources]
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

	 UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclSO = NULL
	  WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )	
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO
------------------------- ========================================= ------------------------------------------
/****** Object:  Trigger [ProjectsSourcesINSERT]    Script Date: 05/20/2011 11:36:52 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsSourcesINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsSourcesINSERT]
GO

/****** Object:  Trigger [dbo].[ProjectsSourcesINSERT]    Script Date: 05/19/2011 14:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsSourcesINSERT] ON [dbo].[ProjectsSources] 
FOR INSERT AS
declare @PeopleID               int
declare @ProjectsID            int
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
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclSO)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclSO = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

------------------------ =========================================== ------------------------------------
/****** Object:  Trigger [ProjectsTargetListsOnDelete]    Script Date: 05/20/2011 11:43:00 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsTargetListsOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsTargetListsOnDelete]
GO
/****** Object:  Trigger [dbo].[ProjectsTargetListsDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[ProjectsTargetListsOnDelete] ON [dbo].[ProjectsTargetLists]
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
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
GO

-------------- ============================= -------------------------------
/****** Object:  Trigger [ProjectsPresentedListsOnDelete]    Script Date: 05/20/2011 11:43:43 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsPresentedListsOnDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsPresentedListsOnDelete]
GO
/****** Object:  Trigger [dbo].[ProjectsPresentedListsDelete]    Script Date: 05/19/2011 14:46:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[ProjectsPresentedListsOnDelete] ON [dbo].[ProjectsPresentedLists]
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
         fetch next from Row into @PeopleID, @ProjectsID

    end
          
close            Row
deallocate  Row
--------------------------- =================================== -------------------------
GO

/****** Object:  Trigger [dbo].[PositionsDelete]    Script Date: 05/19/2011 16:16:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
        fetch next from Row into  @PositionsID, @PeopleID, @ProjectsID, @JobOrdersID
    end
        
close            Row
deallocate  Row
GO

------------------------ ============================================== ------------------------------------

/****** Object:  Trigger [dbo].[PositionsUpdate]    Script Date: 05/19/2011 16:22:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  TRIGGER [dbo].[PositionsUpdate] ON [dbo].[Positions]
FOR UPDATE 
AS
BEGIN

UPDATE  Positions
SET  Positions.UpdatedBy = suser_sname(),
UpdatedOn = GETDATE()
FROM Inserted,  Positions
WHERE Inserted.PositionsID =  Positions.PositionsID

UPDATE Positions
SET  
ExchangeRate = (SELECT CurrentRate FROM ExchangeRates WITH(NOLOCK)
WHERE CurrencyUnit = Inserted.CurrencyType),
ExchangeRateDate = GETDATE()
FROM Inserted JOIN Positions ON
( Inserted.PositionsID = Positions.PositionsID
AND (Inserted.CurrencyType <> Positions.CurrencyType
OR Inserted.BillRate <> Positions.BillRate
OR Inserted.Bonus <> Positions.Bonus
OR Inserted.BonusHigh <> Positions.BonusHigh
OR Inserted.Budget <> Positions.Budget
OR Inserted.CommissionOnCandidate <> Positions.CommissionOnCandidate
OR Inserted.CommissionOnClientOwner <> Positions.CommissionOnClientOwner
OR Inserted.CommissionOnExtOther <> Positions.CommissionOnExtOther
OR Inserted.CommissionOnFill <> Positions.CommissionOnFill
OR Inserted.CommissionOnIntOther <> Positions.CommissionOnIntOther
OR Inserted.CommissionOnPermOrder <> Positions.CommissionOnPermOrder
OR Inserted.CommissionTotal <> Positions.CommissionTotal
OR Inserted.FlatFee <> Positions.FlatFee
OR Inserted.PayRate <> Positions.PayRate
OR Inserted.Salary <> Positions.Salary
OR Inserted.TotalCompensation <> Positions.TotalCompensation
OR Inserted.TotalCompHigh <> Positions.TotalCompHigh
))

END

IF EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus, Inserted WITH(NOLOCK) 
WHERE ProjectsCallStatus.PeopleID = Inserted.PeopleID AND ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND Inserted.ProjectsID > 0)
	UPDATE ProjectsCallStatus SET InclPL = 1
	FROM Inserted,ProjectsCallStatus WHERE 
	(ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND ProjectsCallStatus.PeopleID = Inserted.PeopleID)

IF EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus, Deleted WITH(NOLOCK) 
WHERE ProjectsCallStatus.PeopleID = Deleted.PeopleID AND ProjectsCallStatus.ProjectsID = Deleted.ProjectsID AND Deleted.ProjectsID > 0)
	UPDATE ProjectsCallStatus SET InclPL = NULL
	FROM Deleted,ProjectsCallStatus WHERE 
	(ProjectsCallStatus.ProjectsID = Deleted.ProjectsID AND ProjectsCallStatus.PeopleID = Deleted.PeopleID)
GO