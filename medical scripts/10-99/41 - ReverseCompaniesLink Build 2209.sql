ALTER TABLE TypeOfLinkCompanyToCompanies add RevDescription varchar(50)
go
update LookupTables set Editable ='Description,RevDescription',
Visible = 'Description,RevDescription'  where name ='TypeOfLinkCompanyToCompanies'
go
update TypeOfLinkCompanyToCompanies set RevDescription=Description where RevDescription is null
