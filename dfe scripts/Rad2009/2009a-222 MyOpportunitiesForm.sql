If ( select COUNT(*) from ProgramComponents where Name ='My Opportunities' )=0
insert into ProgramComponents (Name) values('My Opportunities')

