ALTER TABLE Responces add TaskEventDate int
GO 
update DataCashTables set UpdatedOn = getutcdate() where Name='Responces'
