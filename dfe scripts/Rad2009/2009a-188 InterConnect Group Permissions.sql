/* Drop Group Permission column if exists */
IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'AllowInterConnect' AND Object_ID = Object_ID(N'GroupPermissions'))
BEGIN
	ALTER TABLE dbo.GroupPermissions
        DROP COLUMN AllowInterConnect
    
END

GO

if ( select count(*) from ProgramComponents where name='InterConnect' )=0
begin
	insert INTO Programcomponents ( Name ) Values ('InterConnect')
end
