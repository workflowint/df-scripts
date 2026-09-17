ALTER TABLE ActivityTypes add DefaultNotes varchar(max)
GO
UPDATE DataCashTables set UpdatedOn= GETDATE() where Name ='ActivityTypes'