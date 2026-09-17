IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'Projects_EditCandBlock' AND Object_ID = Object_ID(N'GroupPermissions'))
BEGIN
	ALTER TABLE dbo.GroupPermissions
		ADD [Projects_EditCandBlock] bit NULL    
END

GO
