ALTER TABLE UserLastTouch add  DefaultTaskTime datetime
GO
UPDATE UserLastTouch set DefaultTaskTime = cast(cast(cast(0 as datetime) as int)-2 as datetime)+'8:00:00' where DefaultTaskTime is null
GO
ALTER TRIGGER [dbo].[UserListInsert] ON [dbo].[UserList] 
FOR INSERT
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='UserList'
INSERT INTO UserLastTouch ( LoginName,DefaultTaskTime )
SELECT LoginName, cast(cast(cast(0 as datetime) as int)-2 as datetime)+'8:00:00' from Inserted 
INSERT INTO UserEMailSettings (LoginName, FormatType)
SELECT LoginName,1  from Inserted

