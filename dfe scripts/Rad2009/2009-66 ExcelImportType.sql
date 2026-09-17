ALTER TABLE ExcelMapping add ImportType int null
go
UPDATE ExcelMapping set ImportType=0
