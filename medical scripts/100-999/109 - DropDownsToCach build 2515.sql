if ((select count(*) from DataCashTables  where Name='MethodofContact')=0 )
insert into DataCashTables (Name ) Values ('MethodofContact')
go
if ((select count(*) from DataCashTables  where Name='BoardStatus')=0 )
insert into DataCashTables (Name ) Values ('BoardStatus')
go
if ((select count(*) from DataCashTables  where Name='TitlesForContacts')=0 )
insert into DataCashTables (Name ) Values ('TitlesForContacts')
go
if ((select count(*) from DataCashTables  where Name='DFTPeopleStatus')=0 )
insert into DataCashTables (Name ) Values ('DFTPeopleStatus')
go
if ((select count(*) from DataCashTables  where Name='PeopleStatus3')=0 )
insert into DataCashTables (Name ) Values ('PeopleStatus3')
GO
CREATE TRIGGER [dbo].[MethodofContactTrigger] ON [dbo].[MethodofContact] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getutcdate(), UTCUpdatedOn=1 
WHERE Name ='MethodofContact'
GO
CREATE TRIGGER [dbo].[BoardStatusTrigger] ON [dbo].[BoardStatus] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getutcdate(), UTCUpdatedOn=1 
WHERE Name ='BoardStatus'
GO
CREATE TRIGGER [dbo].[TitlesForContactsTrigger] ON [dbo].[TitlesForContacts] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getutcdate(), UTCUpdatedOn=1 
WHERE Name ='TitlesForContacts'
GO
CREATE TRIGGER [dbo].[DFTPeopleStatusTrigger] ON [dbo].[DFTPeopleStatus] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getutcdate(), UTCUpdatedOn=1 
WHERE Name ='DFTPeopleStatus'
GO
CREATE TRIGGER [dbo].[PeopleStatus3Trigger] ON [dbo].[PeopleStatus3] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getutcdate(), UTCUpdatedOn=1 
WHERE Name ='PeopleStatus3'






