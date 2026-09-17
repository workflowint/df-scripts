if ( select count(*) from DataCashTables where name='MajorName')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('MajorName',getdate())
GO
CREATE TRIGGER [dbo].[MajorNameTrigger] ON [dbo].[MajorName] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='MajorName'
GO
if ( select count(*) from DataCashTables where name='CallStatusDescription')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('CallStatusDescription',getdate())
GO
CREATE TRIGGER [dbo].[CallStatusDescriptionTrigger] ON [dbo].[CallStatusDescription] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='CallStatusDescription'