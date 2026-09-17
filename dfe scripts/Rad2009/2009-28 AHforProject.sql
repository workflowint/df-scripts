CREATE TABLE [dbo].[LastProjectActivity](
	[ProjectsID] [int] NOT NULL,
	[PeopleID] [int] NOT NULL,
	[LastProjectAHID] [int] NULL,
	[LASTProjectAHDate] [datetime] NULL)
  ON [PRIMARY]
GO
ALTER TABLE [dbo].[LastProjectActivity] WITH NOCHECK ADD 
	CONSTRAINT [PK_LastProjectActivity] PRIMARY KEY  CLUSTERED 
	(
    	[ProjectsID] ASC,
	    [PeopleID] ASC
	)  ON [PRIMARY] 
GO
CREATE NONCLUSTERED INDEX [LastProjectActivity_ProjectsID] ON [dbo].[LastProjectActivity] 
(
	[ProjectsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastProjectActivity_PeopleID] ON [dbo].[LastProjectActivity] 
(
	[PeopleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LastProjectActivity]  TO [DeskFlowUsers]
GO

INSERT INTO LastProjectActivity ( PeopleID,ProjectsID )
Select distinct LinkObjectToActivityHistory.LeftID as P1, L1.LeftID as P2
from ActivityHistory WITH (NOLOCK)  
JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
and LinkObjectToActivityHistory.ObjectTableName='People'
JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
ActivityHistory.ActivityHistoryID=L1.RightID
and L1.ObjectTableName='Projects'
go

UPDATE LastProjectActivity set LASTProjectAHID=A.ActivityHistoryID,LASTProjectAHDate=A.CompletedOn
from LastProjectActivity,
(Select ActivityHistoryID,LinkObjectToActivityHistory.LeftID,L1.LeftID as LeftID1,CompletedOn,
Rank() over ( partition by LinkObjectToActivityHistory.LeftID,L1.LeftID order By CompletedOn desc ) as dd
from ActivityHistory WITH (NOLOCK)  
JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
and LinkObjectToActivityHistory.ObjectTableName='People'
JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
ActivityHistory.ActivityHistoryID=L1.RightID
and L1.ObjectTableName='Projects') as A
where A.LeftID = LastProjectActivity.PeopleID and 
A.LeftID1 = LastProjectActivity.ProjectsID and dd =1 

