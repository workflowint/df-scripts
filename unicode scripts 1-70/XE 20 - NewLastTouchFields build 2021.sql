ALTER TABLE UserLastTouch add OpenDirectHire tinyint, OpenContract tinyint, OpenMRContract tinyint
GO
ALTER TABLE Responces add ToSelectedRoles bit, SelectedRoles nvarchar(255)
GO 
update DataCashTables set UpdatedOn = getdate() where Name ='Responces' 