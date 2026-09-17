ALTER TABLE Responces add AttachResume bit 
GO
ALTER TABLE  LinkInternalInterviewsToResults add Description varchar(255)
GO
ALTER TABLE  LinkClnInterviewsToResults add Description varchar(255)
GO
ALTER TABLE LinkContactsToOpportunities ALTER COLUMN Rank varchar(100)
GO
ALTER TABLE LinkContactsToOpportunities ALTER COLUMN Rank2 varchar(100)