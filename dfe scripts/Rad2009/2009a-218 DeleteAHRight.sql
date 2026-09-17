IF not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'GroupPermissions'
                 AND COLUMN_NAME = 'ActHistory_Delete')
begin 
 ALTER TABLE GroupPermissions add ActHistory_Delete bit
 EXEC ('update GroupPermissions set ActHistory_Delete = ActHistory_Edit')

end 
