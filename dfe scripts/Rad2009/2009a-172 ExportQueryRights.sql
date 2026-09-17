ALTER TABLE GroupPermissions add EditExportQueries bit 
GO
UPDATE GroupPermissions set EditExportQueries = 1