if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DeleteLinkObjectToActivityHistory]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[DeleteLinkObjectToActivityHistory]

GO
CREATE TRIGGER [dbo].[DeleteLinkObjectToActivityHistory] ON [dbo].[LinkObjectToActivityHistory] 
FOR DELETE
AS
SET NOCOUNT ON;

declare @LeftID int

declare @PeopleID int
declare @ProjectsID int

declare @ObjectName varchar(50)
declare @PrUpdate int
declare @PeUpdate int
declare @Done int

declare CurLoc cursor local for
     select  ObjectTableName,LeftID
from Deleted where ObjectTableName='People' or ObjectTableName ='Projects'
or ObjectTableName ='MarketingCallReport' or ObjectTableName ='SearchContactRecord'

set @Done = 0
open CurLoc

fetch next from CurLoc into @ObjectName,@LeftID

while @@fetch_status = 0
begin
 if ( Upper(@ObjectName)='PEOPLE'  or Upper(@ObjectName)='PROJECTS'  )
  begin 
   if ( Upper(@ObjectName)='PEOPLE' )
		declare CurLoc2 cursor local for
		select Deleted.LeftID,Link2.LeftID,
        PrUpdate = case 	when LASTProjectAHID = Deleted.RightID then 1
                        else 0 end,	
        PeUpdate = case 	when People.LastAHID = Deleted.RightID then 1
                        else 0 end	
		from Deleted 
		JOIN ActivityHistory WITH(NOLOCK) ON ( ActivityHistory.ActivityHistoryID=Deleted.RightID)
        JOIN People WITH(NOLOCK) ON ( Deleted.LeftID = People.PeopleID)
		LEFT JOIN LinkObjectToActivityHistory AS Link2 WITH(NOLOCK)  ON (
		ActivityHistory.ActivityHistoryID=Link2.RightID and Link2.ObjectTableName='Projects')
		LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=Deleted.LeftID and
		LastProjectActivity.ProjectsID=Link2.LeftID ) 
		where IsNull(ActivityHistory.ActivityHistoryID,0)>0 and
		( LASTProjectAHID = Deleted.RightID or People.LastAHID = Deleted.RightID )
   if ( Upper(@ObjectName)='PROJECTS' )
		declare CurLoc2 cursor local for
		select Link2.LeftID,Deleted.LeftID,1,0
		from Deleted 
		JOIN ActivityHistory WITH(NOLOCK) ON ( ActivityHistory.ActivityHistoryID=Deleted.RightID)
		JOIN LinkObjectToActivityHistory AS Link2 WITH(NOLOCK)  ON (
		ActivityHistory.ActivityHistoryID=Link2.RightID and Link2.ObjectTableName='People')
		LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=Link2.LeftID and
		LastProjectActivity.ProjectsID=Deleted.LeftID )  
		where LASTProjectAHID=Deleted.RightID and IsNull(ActivityHistory.ActivityHistoryID,0)>0
-----------------------------------------------------------------------------------------------------------

	open CurLoc2

	fetch next from CurLoc2 into @PeopleID,@ProjectsID, @PrUpdate, @PeUpdate

    while @@fetch_status = 0
     begin
		if ( @PrUpdate > 0 )
         begin		
			UPDATE LastProjectActivity set LASTProjectAHID=NULL,LASTProjectAHDate=NULL
             where PeopleID = @PeopleID and ProjectsID = @ProjectsID 
			UPDATE LastProjectActivity set LASTProjectAHID=
			(Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
			JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
			ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
			and LinkObjectToActivityHistory.ObjectTableName='People' 
			JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
			ActivityHistory.ActivityHistoryID=L1.RightID
			and L1.ObjectTableName='Projects' 
			WHERE LinkObjectToActivityHistory.LeftID = @PeopleID 
			and L1.LeftID = @ProjectsID ORDER BY CompletedOn desc)
			WHERE LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID

			UPDATE LastProjectActivity set LASTProjectAHDate=ActivityHistory.CompletedOn
			FROM LastProjectActivity,ActivityHistory
			WHERE LastProjectActivity.LASTProjectAHID=ActivityHistory.ActivityHistoryID and 
			LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID
		 end
        if ( @PeUpdate > 0 and @Done = 0 )
		  begin
			set @Done = 1

     		UPDATE People set People.LastAHID=
	    	(Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
		    JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
		    ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
		    and ObjectTableName='People'
		    WHERE LinkObjectToActivityHistory.LeftID=@LeftID ORDER BY CompletedOn desc)
            WHERE People.PeopleID = @LeftID

     		UPDATE People set People.LastAHCompletedOn=ActivityHistory.CompletedOn
            From People, ActivityHistory 
            WHERE People.LastAHID=ActivityHistory.ActivityHistoryID and People.PeopleID = @LeftID

          end
        fetch next from CurLoc2 into @PeopleID,@ProjectsID, @PrUpdate, @PeUpdate
    end
   close         CurLoc2
   deallocate CurLoc2
  end
  if(@ObjectName='MarketingCallReport')
	    delete from MarketingCallReport where MarketingCallReportID = @LeftID
  if(@ObjectName='SearchContactRecord')
            delete from SearchContactRecord where SearchContactRecordID = @LeftID

  fetch next from CurLoc into @ObjectName, @LeftID
  end
close         CurLoc
deallocate CurLoc

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LinkObjectToActivityHistoryInsert]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[LinkObjectToActivityHistoryInsert]

GO
CREATE TRIGGER [dbo].[LinkObjectToActivityHistoryInsert] ON [dbo].[LinkObjectToActivityHistory] 
FOR INSERT
AS
SET NOCOUNT ON;

declare @LeftID int
declare @RightID int

declare @PeopleID int
declare @ProjectsID int
declare @AHID int
declare @LASTProjectAHID int
declare @LASTProjectAHDate datetime
declare @AHDate datetime
declare @LASTPeopleAHID int
declare @LASTPeopleAHDate datetime
declare @Done int
declare @ObjectName varchar(50)

declare CurLoc cursor local for
     select  Inserted.ObjectTableName
from Inserted where ObjectTableName='People' or ObjectTableName ='Projects'
set @Done = 0
open CurLoc

fetch next from CurLoc into @ObjectName

while @@fetch_status = 0
begin
 if ( Upper(@ObjectName)='PEOPLE' )
		declare CurLoc2 cursor local for
		select Inserted.LeftID,Link2.LeftID,Inserted.RightID,LASTProjectAHID,LASTProjectAHDate,
		ActivityHistory.CompletedOn,People.LastAHID,People.LastAHCompletedOn
		from Inserted 
		JOIN ActivityHistory WITH(NOLOCK) ON ( ActivityHistory.ActivityHistoryID=Inserted.RightID)
		LEFT JOIN LinkObjectToActivityHistory AS Link2 WITH(NOLOCK)  ON (
		ActivityHistory.ActivityHistoryID=Link2.RightID and Link2.ObjectTableName='Projects')
		LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=Inserted.LeftID and
		LastProjectActivity.ProjectsID=Link2.LeftID )
        LEFT JOIN People WITH(NOLOCK) ON (People.LastAHID = ActivityHistory.ActivityHistoryID)
 if ( Upper(@ObjectName)='PROJECTS' )
		declare CurLoc2 cursor local for
		select Link2.LeftID,Inserted.LeftID,Inserted.RightID,LASTProjectAHID,LASTProjectAHDate,
		ActivityHistory.CompletedOn, 0, getdate()
		from Inserted 
		JOIN ActivityHistory WITH(NOLOCK) ON ( ActivityHistory.ActivityHistoryID=Inserted.RightID)
		JOIN LinkObjectToActivityHistory AS Link2 WITH(NOLOCK)  ON (
		ActivityHistory.ActivityHistoryID=Link2.RightID and Link2.ObjectTableName='People')
		LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=Link2.LeftID and
		LastProjectActivity.ProjectsID=Inserted.LeftID )
-----------------------------------------------------------------------------------------------------------

	open CurLoc2

	fetch next from CurLoc2 into @PeopleID,@ProjectsID,@AHID,@LASTProjectAHID,@LASTProjectAHDate,@AHDate,
                                 @LASTPeopleAHID,@LASTPeopleAHDate

    while @@fetch_status = 0
     begin
       if (@ProjectsID > 0)
        begin
		if ( @LASTProjectAHDate < @AHDate or @LASTProjectAHDate is null)
		  begin
        if NOT EXISTS ( Select ProjectsID from LastProjectActivity  where PeopleID = @PeopleID and ProjectsID = @ProjectsID )
			INSERT INTO LastProjectActivity ( PeopleID,ProjectsID,LASTProjectAHID,LASTProjectAHDate )
			Values ( @PeopleID,@ProjectsID,@AHID,@AHDate)
		Else
			UPDATE LastProjectActivity set LASTProjectAHID=@AHID,LASTProjectAHDate=@AHDate
		    where PeopleID =@PeopleId and ProjectsID=@ProjectsID
          end
         end
		if ( (@LASTPeopleAHDate < @AHDate or @LASTPeopleAHDate is null) and @Done=0 )
		  begin
            Set @Done = 1
			UPDATE People set LastAHID = @AHID,LastAHCompletedOn=@AHDate
		    where PeopleID =@PeopleId
          end

        fetch next from CurLoc2 into @PeopleID,@ProjectsID,@AHID,@LASTProjectAHID,@LASTProjectAHDate,@AHDate,
                                     @LASTPeopleAHID,@LASTPeopleAHDate
      end
     close         CurLoc2
     deallocate CurLoc2

   fetch next from CurLoc into @ObjectName
   end
close         CurLoc
deallocate CurLoc

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DeleteActivityHistory]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[DeleteActivityHistory]
go

CREATE TRIGGER [dbo].[DeleteActivityHistory] ON [dbo].[ActivityHistory] 
FOR DELETE 
AS
SET NOCOUNT ON;
declare @PeopleID int
declare @ProjectsID int
declare @PrUpdate int
declare @PeUpdate int
declare @Done int
declare CurLoc1 cursor local for
     select  LinkObjectToActivityHistory.LeftID,L1.LeftID as LeftIDPr,
        PrUpdate = case 	when Deleted.ActivityHistoryID = LASTProjectAHID then 1
                        else 0 end,	
        PeUpdate = case 	when Deleted.ActivityHistoryID=People.LastAHID then 1
                        else 0 end	
from Deleted JOIN LinkObjectToActivityHistory  WITH (NOLOCK)
ON ( Deleted.ActivityHistoryID =LinkObjectToActivityHistory.RightID AND 
     LinkObjectToActivityHistory.ObjectTableName='People')
LEFT JOIN LinkObjectToActivityHistory  AS L1 WITH (NOLOCK)
ON ( Deleted.ActivityHistoryID =L1.RightID AND L1.ObjectTableName='Projects')
LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=LinkObjectToActivityHistory.LeftID and
      	  LastProjectActivity.ProjectsID=L1.LeftID )
LEFT JOIN People WITH(NOLOCK) on (People.PeopleID = LinkObjectToActivityHistory.LeftID) 
where (Deleted.ActivityHistoryID = LASTProjectAHID or Deleted.ActivityHistoryID=People.LastAHID )
set @Done = 0
open CurLoc1

fetch next from CurLoc1 into @PeopleID, @ProjectsID, @PrUpdate, @PeUpdate

while @@fetch_status = 0
  begin
	if (@PrUpdate = 1 )
       begin

			UPDATE LastProjectActivity set LASTProjectAHID=NULL,LASTProjectAHDate=NULL
             where PeopleID = @PeopleID and ProjectsID = @ProjectsID 
			UPDATE LastProjectActivity set LASTProjectAHID=
			(Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
			JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
			ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
			and LinkObjectToActivityHistory.ObjectTableName='People' 
			JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
			ActivityHistory.ActivityHistoryID=L1.RightID
			and L1.ObjectTableName='Projects' 
			WHERE LinkObjectToActivityHistory.LeftID = @PeopleID 
			and L1.LeftID = @ProjectsID ORDER BY CompletedOn desc)
			WHERE LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID

			UPDATE LastProjectActivity set LASTProjectAHDate=ActivityHistory.CompletedOn
			FROM LastProjectActivity,ActivityHistory
			WHERE LastProjectActivity.LASTProjectAHID=ActivityHistory.ActivityHistoryID and 
			LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID
       end
        if ( @PeUpdate > 0 and @Done = 0 )
		  begin
     		set @Done = 1

     		UPDATE People set People.LastAHID=
	    	(Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
		    JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
		    ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
		    and ObjectTableName='People'
		    WHERE LinkObjectToActivityHistory.LeftID=@PeopleID ORDER BY CompletedOn desc)
            WHERE People.PeopleID = @PeopleID

     		UPDATE People set People.LastAHCompletedOn=ActivityHistory.CompletedOn
            From People, ActivityHistory 
            WHERE People.LastAHID=ActivityHistory.ActivityHistoryID and People.PeopleID = @PeopleID

          end

        fetch next from CurLoc1 into @PeopleID, @ProjectsID, @PrUpdate, @PeUpdate
end
          
close         CurLoc1
deallocate CurLoc1


delete from LinkObjectToActivityHistory from LinkObjectToActivityHistory,Deleted
       where LinkObjectToActivityHistory.RightID = Deleted.ActivityHistoryID
delete from LinkUsersToActivityHistory  from LinkUsersToActivityHistory,deleted
	    where LinkUsersToActivityHistory.ActivityHistoryID = Deleted.ActivityHistoryID
UPDATE ActivityHistory SET ParentAHID = NULL from ActivityHistory,deleted 
        WHERE ActivityHistory.ParentAHID = Deleted.ActivityHistoryID

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ActivityHistoryUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ActivityHistoryUpdate]
GO

CREATE  TRIGGER [dbo].[ActivityHistoryUpdate] ON [dbo].[ActivityHistory]
FOR UPDATE 
AS
SET NOCOUNT ON
UPDATE  ActivityHistory
SET  ActivityHistory.UpdatedBy = suser_sname(),
UpdatedOn = GETDATE()
FROM Inserted,  ActivityHistory 
WHERE Inserted.ActivityHistoryID =  ActivityHistory.ActivityHistoryID

declare @PeopleID int
declare @ProjectsID int
declare @AHID int
declare @LASTProjectAHID int
declare @LASTProjectAHDate datetime
declare @AHDate datetime

declare @LASTPeopleAHID int
declare @LASTPeopleAHDate datetime

declare @Done int

declare CurLoc1 cursor local for
     select  LinkObjectToActivityHistory.LeftID,L1.LeftID as LeftIDPr,Inserted.ActivityHistoryID,
			 LASTProjectAHID,LASTProjectAHDate,Inserted.CompletedOn,  People.LastAHID,People.LastAHCompletedOn
from Inserted JOIN Deleted ON
( Inserted.ActivityHistoryID=Deleted.ActivityHistoryID )
JOIN LinkObjectToActivityHistory  WITH (NOLOCK)
ON ( Inserted.ActivityHistoryID =LinkObjectToActivityHistory.RightID AND 
     LinkObjectToActivityHistory.ObjectTableName='People')
LEFT JOIN LinkObjectToActivityHistory  AS L1 WITH (NOLOCK)
ON ( Inserted.ActivityHistoryID =L1.RightID AND L1.ObjectTableName='Projects')
LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=LinkObjectToActivityHistory.LeftID and
      	  LastProjectActivity.ProjectsID=L1.LeftID )
LEFT JOIN People WITH(NOLOCK) on (People.PeopleID = LinkObjectToActivityHistory.LeftID )
WHERE Inserted.CompletedOn<>Deleted.CompletedOn 
-----------------------------------------------------------------------------------------------------------
set @Done = 0
open CurLoc1

fetch next from CurLoc1 into @PeopleID, @ProjectsID,@AHID, @LASTProjectAHID,@LASTProjectAHDate,@AHDate,
							 @LASTPeopleAHID, @LASTPeopleAHDate
while @@fetch_status = 0
    begin
      if ( @ProjectsID > 0 )
         begin
             if ( (@AHID = @LASTProjectAHID and @AHDate < @LASTProjectAHDate) or (@AHID <> @LASTProjectAHID and @AHDate > @LASTProjectAHDate ))
              begin
 			    UPDATE LastProjectActivity set LASTProjectAHID=NULL,LASTProjectAHDate=NULL
                where PeopleID = @PeopleID and ProjectsID = @ProjectsID 
			    UPDATE LastProjectActivity set LASTProjectAHID=
			    (Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
			    JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
			    ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
			    and LinkObjectToActivityHistory.ObjectTableName='People' 
			    JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
			    ActivityHistory.ActivityHistoryID=L1.RightID
			    and L1.ObjectTableName='Projects' 
			    WHERE LinkObjectToActivityHistory.LeftID = @PeopleID 
			    and L1.LeftID = @ProjectsID ORDER BY CompletedOn desc)
			    WHERE LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID

  			    UPDATE LastProjectActivity set LASTProjectAHDate=ActivityHistory.CompletedOn
			    FROM LastProjectActivity,ActivityHistory
			    WHERE LastProjectActivity.LASTProjectAHID=ActivityHistory.ActivityHistoryID and 
			    LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID
			  end
             if ( @AHID = @LASTProjectAHID and @AHDate > @LASTProjectAHDate) 
	     		UPDATE LastProjectActivity set LASTProjectAHDate=@AHDate where LASTProjectAHID=@LASTProjectAHID
         end
	if ( @Done = 0 )
       begin
            set @Done = 1 
			if ( (@AHID = @LASTPeopleAHID and @AHDate < @LASTPeopleAHDate ) or (@AHID <> @LASTPeopleAHID and @AHDate > @LASTPeopleAHDate ))
              begin  
        		UPDATE People set People.LastAHID=
	    	    (Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
		        JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
		        ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
		        and ObjectTableName='People'
		        WHERE LinkObjectToActivityHistory.LeftID=@PeopleID ORDER BY CompletedOn desc)
                WHERE People.PeopleID = @PeopleID

     			UPDATE People set People.LastAHCompletedOn=ActivityHistory.CompletedOn
				From People, ActivityHistory 
				WHERE People.LastAHID=ActivityHistory.ActivityHistoryID and People.PeopleID = @PeopleID
			  end
             if ( @AHID = @LASTPeopleAHID and @AHDate > @LASTPeopleAHDate ) 
	     		UPDATE People set LastAHCompletedOn = @AHDate where PeopleID = @PeopleID		
       end  
        fetch next from CurLoc1 into @PeopleID, @ProjectsID,@AHID, @LASTProjectAHID,@LASTProjectAHDate,@AHDate,
                                     @LASTPeopleAHID, @LASTPeopleAHDate
end
          
close         CurLoc1
deallocate CurLoc1






