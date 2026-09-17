/****** Object:  Trigger [dbo].[ProjectsFileSearchCandidatesINSERT]    Script Date: 04/28/2015 17:07:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[ProjectsFileSearchCandidatesINSERT] ON [dbo].[ProjectsFileSearchCandidates] 
FOR INSERT AS
declare @PeopleID               int
declare @ProjectsID             int
declare @BlockLevel             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
set @BlockLevel = (select BlockLevel from Worklists where listName = 'File Search')
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
	if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'File Search'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[ProjectTargetCompaniesCandidatesINSERT]    Script Date: 04/28/2015 17:38:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectTargetCompaniesCandidatesINSERT] ON [dbo].[ProjectTargetCompaniesCandidates] 
FOR INSERT AS
declare @PeopleID               int
declare @ProjectsID             int
declare @BlockLevel             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Target Companies')
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
    if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'Target Companies'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[ProjectsClientEmployeesListsINSERT]    Script Date: 04/28/2015 17:42:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsClientEmployeesListsINSERT] ON [dbo].[ProjectsClientEmployeesLists] 
FOR INSERT AS

declare @PeopleID               int
declare @ProjectsID             int
declare @BlockLevel             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Internal Search')
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
	if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'Internal Search'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[CandidateReferralsINSERT]    Script Date: 04/28/2015 17:44:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[CandidateReferralsINSERT] ON [dbo].[CandidateReferrals] 
FOR INSERT AS
declare @PeopleID int
declare @ProjectsID             int
declare @BlockLevel             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Referrals')
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
	if ( @BlockLevel > 0 and @ProjectsID >0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'Referrals'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[ProjectsTargetListsINSERT]    Script Date: 04/28/2015 17:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsTargetListsINSERT] ON [dbo].[ProjectsTargetLists] 
FOR INSERT AS 

declare @PeopleID    int
declare @ProjectsID  int
declare @BlockLevel             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Contact Register')
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
	if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'Contact Register'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[ProjectsInternalInterviewListsINSERT]    Script Date: 04/28/2015 17:46:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsInternalInterviewListsINSERT] ON [dbo].[ProjectsInternalInterviewLists] 
FOR INSERT AS
declare @PeopleID int
declare @ProjectsID int
declare @BlockLevel             int
declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Internal Interview')
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
	if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'Internal Interview'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[ProjectsPresentedListsINSERT]    Script Date: 04/28/2015 17:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsPresentedListsINSERT] ON [dbo].[ProjectsPresentedLists] 
FOR INSERT AS 
declare @PeopleID int
declare @ProjectsID int
declare @BlockLevel             int
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Presented')
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
	if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
		BlockDescription = (select Caption from Worklists where listName = 'Presented'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row

GO
/****** Object:  Trigger [dbo].[ProjectsShortListsINSERT]    Script Date: 04/28/2015 17:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[ProjectsShortListsINSERT] ON [dbo].[ProjectsShortLists] 
FOR INSERT AS
---------------------------------------------------------------------------------------------------------- 
declare @PeopleID               int
declare @ProjectsID             int
declare @BlockLevel             int

declare Row cursor local  for
     select 
         PeopleID,
         ProjectsID
     from 
         Inserted
open Row
set @BlockLevel = (select BlockLevel from Worklists where listName = 'Client Interview')

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
    if ( @BlockLevel > 0 )
		UPDATE People set CandidateBlockStatus = @BlockLevel,
        BlockDescription = (select Caption from Worklists where listName = 'Client Interview'),
		CandidateBlockProjectsID = @ProjectsID FROM people,Projects,ProjectStatus 
		where People.PeopleID = @PeopleID and Projects.ProjectsID=@ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
		and IsNull(CandidateBlockStatus,0) <= @BlockLevel
        fetch next from Row into @PeopleID, @ProjectsID
END   
close  Row
deallocate  Row





