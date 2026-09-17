ALTER TABLE Positions add AssistantID int, AssistantAsRecord bit
GO
UPDATE DataCashTables set UpdatedOn = getdate() where Name = 'projecttype'
