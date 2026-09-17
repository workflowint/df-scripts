ALTER TABLE GroupPermissions add UseDocuSign bit
GO
ALTER TABLE ClientConfig add DocuSignText nvarchar(max)
GO
ALTER TABLE Projects add ProjectDocuSignText nvarchar(max)
