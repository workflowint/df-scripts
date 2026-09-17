ALTER TABLE ClientConfig add CompMainLocation varchar(20)
go
if ( select COUNT(*) from ClientConfig where ISNULL(CompMainLocation,'')='')=1
update ClientConfig set CompMainLocation ='HEAD'
GO
If ( select COUNT(*) from ProgramComponents where Name ='My Accounts' )=0
insert into ProgramComponents (Name) values('My Accounts')
GO
ALTER TABLE ClientConfig add AHCompletedOnFromSCRUpdatedOn bit
