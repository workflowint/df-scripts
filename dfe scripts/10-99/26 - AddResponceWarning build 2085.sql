ALTER TABLE Responces add Warning int
go
update DataCashTables set UpdatedOn= GETDATE() where Name ='Responces'
