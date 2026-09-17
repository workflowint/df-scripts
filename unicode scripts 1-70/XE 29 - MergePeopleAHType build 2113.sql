if ( select COUNT(*) from ActivityTypes where TypeName='People Merge') =0
insert into ActivityTypes ( TypeName ) values ('People Merge')
GO
ALTER TABLE Responces add TaskEventDate int
GO 
update DataCashTables set UpdatedOn = getutcdate() where Name='Responces'

