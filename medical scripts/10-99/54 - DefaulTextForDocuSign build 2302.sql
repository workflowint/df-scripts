ALTER TABLE GroupPermissions add UseDocuSign bit
GO
ALTER TABLE ClientConfig add DocuSignText varchar(max)
GO
ALTER TABLE Projects add ProjectDocuSignText varchar(max)
