ALTER TABLE UserLastTouch add SCRAHForSearchOnly bit default 1
GO
ALTER TABLE People add LastAHCompletedOn datetime
GO
Update UserLastTouch set SCRAHForSearchOnly=1
GO
ALTER TABLE People DISABLE TRIGGER PeopleUpdate
ALTER TABLE People DISABLE TRIGGER PeopleAudit
UPDATE People set
LastAHID =(SELECT TOP 1 ActivityHistoryID FROM ActivityHistory WITH(NOLOCK) 
JOIN LinkObjectToActivityHistory WITH(NOLOCK) ON 
(ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID and ObjectTableName='People')
WHERE LinkObjectToActivityHistory.LeftID=People.PeopleID 
ORDER BY CompletedOn desc)

UPDATE People set
LastAHCompletedOn =(SELECT TOP 1 CompletedOn FROM ActivityHistory WITH(NOLOCK) 
JOIN LinkObjectToActivityHistory WITH(NOLOCK) ON 
(ActivityHistory.ActivityHistoryID=LinkObjectToActivityHistory.RightID and ObjectTableName='People')
WHERE LinkObjectToActivityHistory.LeftID=People.PeopleID 
ORDER BY CompletedOn desc)

ALTER TABLE People ENABLE TRIGGER PeopleUpdate
ALTER TABLE People ENABLE TRIGGER PeopleAudit
