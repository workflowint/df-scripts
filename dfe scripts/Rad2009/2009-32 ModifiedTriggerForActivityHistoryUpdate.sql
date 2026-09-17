
/****** Object:  Trigger [dbo].[ActivityHistoryUpdate]    Script Date: 09/01/2011 12:36:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[ActivityHistoryUpdate] ON [dbo].[ActivityHistory]
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


declare CurLoc1 cursor local for
     select  LinkObjectToActivityHistory.LeftID,L1.LeftID as LeftIDPr,Inserted.ActivityHistoryID,
			 LASTProjectAHID,LASTProjectAHDate,Inserted.CompletedOn
from Inserted JOIN Deleted ON
( Inserted.ActivityHistoryID=Deleted.ActivityHistoryID )
JOIN LinkObjectToActivityHistory  WITH (NOLOCK)
ON ( Inserted.ActivityHistoryID =LinkObjectToActivityHistory.RightID AND 
     LinkObjectToActivityHistory.ObjectTableName='People')
JOIN LinkObjectToActivityHistory  AS L1 WITH (NOLOCK)
ON ( Inserted.ActivityHistoryID =L1.RightID AND L1.ObjectTableName='Projects')
LEFT JOIN LastProjectActivity WITH(NOLOCK) on (LastProjectActivity.PeopleID=LinkObjectToActivityHistory.LeftID and
      	  LastProjectActivity.ProjectsID=L1.LeftID )
WHERE Inserted.CompletedOn<>Deleted.CompletedOn 
-----------------------------------------------------------------------------------------------------------

open CurLoc1

fetch next from CurLoc1 into @PeopleID, @ProjectsID,@AHID, @LASTProjectAHID,@LASTProjectAHDate,@AHDate

while @@fetch_status = 0
            begin
             if ( @AHID = @LASTProjectAHID and @AHDate < @LASTProjectAHDate ) 
              begin
	     		UPDATE LastProjectActivity set LASTProjectAHID=A.ActivityHistoryID,LASTProjectAHDate=A.CompletedOn
		        from LastProjectActivity,
			    (Select ActivityHistoryID,LinkObjectToActivityHistory.LeftID,L1.LeftID as LeftID1,CompletedOn,
				Rank() over ( partition by LinkObjectToActivityHistory.LeftID,L1.LeftID order By CompletedOn desc) as dd
				from ActivityHistory WITH (NOLOCK)  
				JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
				ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
				and LinkObjectToActivityHistory.ObjectTableName='People'
				JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
				ActivityHistory.ActivityHistoryID=L1.RightID
				and L1.ObjectTableName='Projects') as A
				where LastProjectActivity.PeopleID=A.LeftID and 
                  LastProjectActivity.ProjectsID=A.LeftID1
				  and LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID and dd =1 
			  end
             if ( @AHDate > @LASTProjectAHDate )
              begin
	     		UPDATE LastProjectActivity set LASTProjectAHID=@AHID, LASTProjectAHDate=@AHDate 
				where LastProjectActivity.PeopleID = @PeopleID and LastProjectActivity.ProjectsID = @ProjectsID
			  end
           
        fetch next from CurLoc1 into @PeopleID, @ProjectsID,@AHID, @LASTProjectAHID,@LASTProjectAHDate,@AHDate
end
          
close         CurLoc1
deallocate CurLoc1






