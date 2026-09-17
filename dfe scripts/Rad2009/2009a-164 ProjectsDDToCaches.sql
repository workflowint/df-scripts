if ( select count(*) from DataCashTables where name='WorkGroups')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('WorkGroups',getdate())
GO
CREATE TRIGGER [dbo].[WorkGroupsTrigger] ON [dbo].[WorkGroups] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='WorkGroups'
GO
if ( select count(*) from DataCashTables where name='ObjectOrigin')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('ObjectOrigin',getdate())
GO
CREATE TRIGGER [dbo].[ObjectOriginTrigger] ON [dbo].[ObjectOrigin] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='ObjectOrigin'
GO
if ( select count(*) from DataCashTables where name='IntInterviewResults')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('IntInterviewResults',getdate())
GO
CREATE TRIGGER [dbo].[IntInterviewResultsTrigger] ON [dbo].[IntInterviewResults] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='IntInterviewResults'
GO
if ( select count(*) from DataCashTables where name='IntIntResultsLookup')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('IntIntResultsLookup',getdate())
GO
CREATE TRIGGER [dbo].[IntIntResultsLookupTrigger] ON [dbo].[IntIntResultsLookup] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='IntIntResultsLookup'
GO