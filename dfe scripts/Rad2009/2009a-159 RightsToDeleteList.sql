ALTER TABLE GroupPermissions add CanDeleteListFolder bit 
GO
update GroupPermissions set CanDeleteListFolder = 1
GO
delete from programcomponents where Name='Contact Manager'