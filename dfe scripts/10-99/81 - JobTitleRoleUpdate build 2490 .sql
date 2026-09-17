ALTER TABLE Titles add RoleCode1 int, RoleCode2 int
GO
update LookupTables set Editable='JobTitle,JobType,RoleCode1,RoleCode2',
Visible='JobTitle,JobType,RoleCode1,RoleCode2'
where Name='Titles'