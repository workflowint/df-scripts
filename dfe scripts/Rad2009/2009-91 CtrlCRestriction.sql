ALTER TABLE GroupPermissions add AllowCtrlC bit
GO
IF ( select count(*) from ProgramComponents where Name='Exports Log')=0
INSERT INTO ProgramComponents (Name) VALUES ( 'Exports Log' )
GO
IF ( select count(*) from LookupTables where Name ='InterviewOutcome')=0
INSERT INTO LookupTables (Name,Description,Editable,Visible)
VALUES ('InterviewOutcome','Project Client Interview Outcome','Description','Description')

