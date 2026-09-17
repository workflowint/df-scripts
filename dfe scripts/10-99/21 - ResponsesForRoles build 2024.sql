ALTER TABLE Responces add ToSelectedRoles bit, SelectedRoles varchar(255)
GO 
update DataCashTables set UpdatedOn = getdate() where Name ='Responces' 