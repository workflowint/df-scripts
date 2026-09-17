ALTER TABLE LinkClnInterviewsToResults add CreatedBy nvarchar(20) default (suser_sname()),
UpdatedBy nvarchar(20) default (suser_sname()),
CreatedOn datetime DEFAULT (getutcdate()), UpdatedOn datetime DEFAULT (getutcdate()),
UTCCreatedOn smallint DEFAULT ((1)), UTCUpdatedOn smallint DEFAULT ((1))
go
ALTER TABLE LinkInternalInterviewsToResults add CreatedBy nvarchar(20) default (suser_sname()),
UpdatedBy nvarchar(20) default (suser_sname()),
CreatedOn datetime DEFAULT (getutcdate()), UpdatedOn datetime DEFAULT (getutcdate()),
UTCCreatedOn smallint DEFAULT ((1)), UTCUpdatedOn smallint DEFAULT ((1))
go
CREATE TRIGGER [dbo].[LinkClnInterviewsToResultsUpdate] ON [dbo].[LinkClnInterviewsToResults] 
FOR UPDATE
NOT FOR REPLICATION
AS
UPDATE  LinkClnInterviewsToResults
SET  LinkClnInterviewsToResults.UpdatedBy = suser_sname(),
LinkClnInterviewsToResults.UpdatedOn = getutcdate(), 
LinkClnInterviewsToResults.UTCUpdatedOn=1 
FROM LinkClnInterviewsToResults JOIN Inserted 
ON LinkClnInterviewsToResults.LinkClnInterviewsToResultsID = Inserted.LinkClnInterviewsToResultsID  
go
CREATE TRIGGER [dbo].[LinkInternalInterviewsToResultsUpdate] ON [dbo].[LinkInternalInterviewsToResults] 
FOR UPDATE
NOT FOR REPLICATION
AS
UPDATE  LinkInternalInterviewsToResults
SET  LinkInternalInterviewsToResults.UpdatedBy = suser_sname(),
LinkInternalInterviewsToResults.UpdatedOn = getutcdate(), 
LinkInternalInterviewsToResults.UTCUpdatedOn=1 
FROM LinkInternalInterviewsToResults JOIN Inserted 
ON LinkInternalInterviewsToResults.LinkIntInterviewsToResultsID = Inserted.LinkIntInterviewsToResultsID  

