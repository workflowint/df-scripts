if ( select count(*) from DataCashTables where name='PositionsGrades')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('PositionsGrades',getdate())
GO
CREATE TRIGGER [dbo].[PositionsGradesTrigger] ON [dbo].[PositionsGrades] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='PositionsGrades'
GO
if ( select count(*) from DataCashTables where name='TypeOfLinkPeopleToCompanies')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('TypeOfLinkPeopleToCompanies',getdate())
GO
CREATE TRIGGER [dbo].[TypeOfLinkPeopleToCompaniesTrigger] ON [dbo].[TypeOfLinkPeopleToCompanies] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='TypeOfLinkPeopleToCompanies'
GO
if ( select count(*) from DataCashTables where name='StatusOfLinkPeopleToCompanies')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('StatusOfLinkPeopleToCompanies',getdate())
GO

CREATE TRIGGER [dbo].[StatusOfLinkPeopleToCompaniesTrigger] ON [dbo].[StatusOfLinkPeopleToCompanies] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='StatusOfLinkPeopleToCompanies'

GO
if ( select count(*) from DataCashTables where name='AccExpCustomLookup1')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('AccExpCustomLookup1',getdate())
GO

CREATE TRIGGER [dbo].[AccExpCustomLookup1Trigger] ON [dbo].[AccExpCustomLookup1] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='AccExpCustomLookup1'

GO
if ( select count(*) from DataCashTables where name='AccExpCustomLookup2')=0
INSERT INTO DataCashTables (Name,UpdatedOn) VALUES ('AccExpCustomLookup2',getdate())
GO

CREATE TRIGGER [dbo].[AccExpCustomLookup2Trigger] ON [dbo].[AccExpCustomLookup2] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='AccExpCustomLookup2'

