IF ( SELECT COUNT(*) FROM DataCashTables WHERE Name='WorkLists' )=0
INSERT INTO DataCashTables ( Name,UpdatedOn) VALUES('WorkLists',getdate())

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WorkListsTrigger]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[WorkListsTrigger]
GO
CREATE TRIGGER WorkListsTrigger ON [dbo].[WorkLists] 
FOR INSERT, UPDATE, DELETE 
AS

UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='WorkLists'
GO
