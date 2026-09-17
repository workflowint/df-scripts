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
)
GO
CREATE NONCLUSTERED INDEX [LastProjectActivity_PeopleID] ON [dbo].[LastProjectActivity] 
(
	[PeopleID] ASC
)
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

UPDATE LastProjectActivity set LASTProjectAHID=
(Select Top 1 ActivityHistoryID from ActivityHistory WITH (NOLOCK)  
JOIN LinkObjectToActivityHistory WITH (NOLOCK) ON  
ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID
and LinkObjectToActivityHistory.ObjectTableName='People' 
JOIN LinkObjectToActivityHistory AS L1 WITH (NOLOCK) ON  
ActivityHistory.ActivityHistoryID=L1.RightID
and L1.ObjectTableName='Projects' 
WHERE LinkObjectToActivityHistory.LeftID=LastProjectActivity.PeopleID 
and L1.LeftID =LastProjectActivity.ProjectsID ORDER BY CompletedOn desc)

UPDATE LastProjectActivity set LASTProjectAHDate=ActivityHistory.CompletedOn
FROM LastProjectActivity,ActivityHistory
WHERE LastProjectActivity.LASTProjectAHID=ActivityHistory.ActivityHistoryID

