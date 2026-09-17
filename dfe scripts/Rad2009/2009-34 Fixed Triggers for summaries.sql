/****** Object:  Trigger [ProjectsShortListsINSERTMC]    Script Date: 05/20/2011 11:04:43 ******/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsShortListsINSERTMC]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsShortListsINSERTMC]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsShortListsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsShortListsINSERT]
GO

/****** Object:  Trigger [dbo].[ProjectsShortListsINSERT]    Script Date: 05/20/2011 11:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[ProjectsShortListsINSERT] ON [dbo].[ProjectsShortLists] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

------------------- =========================== ------------------
/****** Object:  Trigger [PeopleAppliedToINSERTMC]    Script Date: 05/20/2011 11:13:45 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PeopleAppliedToINSERTMC]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[PeopleAppliedToINSERTMC]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PeopleAppliedToINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[PeopleAppliedToINSERT]
GO

/****** Object:  Trigger [dbo].[PeopleAppliedToINSERTMC]    Script Date: 05/20/2011 11:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[PeopleAppliedToINSERT] ON [dbo].[PeopleAppliedTo] 
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
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclAR)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclAR = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

------------------------ =========================================== ------------------------------------
/****** Object:  Trigger [ProjectsTargetListsINSERTMC]    Script Date: 05/20/2011 11:02:00 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsTargetListsINSERTMC]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsTargetListsINSERTMC]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsTargetListsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsTargetListsINSERT]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsTargetListsINSERT] ON [dbo].[ProjectsTargetLists] 
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
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclCR)
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )
	END
	ELSE 
		UPDATE ProjectsCallStatus SET InclCR = 1
		WHERE (ProjectsCallStatus.ProjectsID = @ProjectsID AND ProjectsCallStatus.PeopleID = @PeopleID)
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO
---------------------------- ============================================ -------------------------------
/****** Object:  Trigger [ProjectsPresentedListsINSERTMC]    Script Date: 05/20/2011 11:03:12 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsPresentedListsINSERTMC]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsPresentedListsINSERTMC]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProjectsPresentedListsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ProjectsPresentedListsINSERT]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
 CREATE TRIGGER [dbo].[ProjectsPresentedListsINSERT] ON [dbo].[ProjectsPresentedLists] 
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
        fetch next from Row into @PeopleID, @ProjectsID
    END   
close  Row
deallocate  Row
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PositionsINSERT]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[PositionsINSERT]
GO


CREATE  TRIGGER [dbo].[PositionsINSERT] ON [dbo].[Positions]
FOR INSERT 
AS
BEGIN

IF EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus, Inserted WITH(NOLOCK) 
WHERE ProjectsCallStatus.PeopleID = Inserted.PeopleID AND ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND Inserted.ProjectsID > 0)
	UPDATE ProjectsCallStatus SET InclPL = 1
	FROM Inserted,ProjectsCallStatus WHERE 
	(ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND ProjectsCallStatus.PeopleID = Inserted.PeopleID)


END
