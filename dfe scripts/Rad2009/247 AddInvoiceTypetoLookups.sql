IF (select count(*) from LookupTables where name = 'InvoiceDetailsTypes' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('InvoiceDetailsTypes','Invoice Item Type','Description','Name,Description')
GO
Update LookupTables set CanDelete = 1
