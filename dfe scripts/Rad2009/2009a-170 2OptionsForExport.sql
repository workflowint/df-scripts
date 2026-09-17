ALTER TABLE UserLastTouch add ProjectListsAHForSearchOnly bit 
go
update UserLastTouch set ProjectListsAHForSearchOnly = SCRAHForSearchOnly
GO
if ( select count(*) from ProgramComponents where name='Export to Outlook' )=0
begin
insert INTO Programcomponents ( Name ) Values ('Export to Outlook')
update Programcomponents set Name = 'Export to Excel' where Name='Export to Excel or Outlook'

declare @ID1 int
declare @ID2 int
set @ID1= (select ProgramComponentsID from Programcomponents where Name='Export to Excel')
set @ID2= (select ProgramComponentsID from Programcomponents where Name='Export to Outlook')

update WorkGroups set ProgramComponents = ProgramComponents+','+LTRIM(RTRIM(Str(@ID2)))
where (ProgramComponents like LTRIM(RTRIM(Str(@ID1)))+',%' or 
'%,'+ProgramComponents like LTRIM(RTRIM(Str(@ID1))) or ProgramComponents like '%,'+LTRIM(RTRIM(Str(@ID1)))+',%')
end

