ALTER TABLE CompaniesSpecificType add Code varchar(2)
GO
if ( select count(*) from LookupTables where Name='CompaniesSpecificType')=0
INSERT INTO LookupTables
VALUES ( 'CompaniesSpecificType', 'Org. Type for COMPANIES', 'Description,Code,TableName,FrameName', 'Description,Code,TableName,FrameName', 0)
GO
if ( select count(*) from DataCashTables where name='CompaniesSpecificType')=0
INSERT INTO DataCashTables (Name) VALUES ('CompaniesSpecificType')
GO
ALTER TABLE ClientConfig add ShowNoDefaultEmailWarn bit 
go
update ClientConfig set ShowNoDefaultEmailWarn=0
GO
if ( select count(*) from DataCashTables where name='DegreeName')=0
INSERT INTO DataCashTables (Name) VALUES ('DegreeName')
GO

CREATE TRIGGER [dbo].[DegreeNameTrigger] ON [dbo].[DegreeName] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='DegreeName'

