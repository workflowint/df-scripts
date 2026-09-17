--addresses

alter table Addresses drop constraint PK_Addresses
go

drop index Addresses_City on Addresses
go

alter table Addresses add constraint pk_Addresses primary key clustered(AddressesID)
go

create index Addresses_City on Addresses(City)
go


alter index all on Addresses rebuild
go

--resumes
drop fulltext index on Resumes
go


alter table resumes drop constraint resumesid
go

drop index contactsid on resumes
go

alter table resumes add constraint ResumesID primary key clustered(ResumesID)
go

create index ContactsID on RESUmes(PeopleID)
go

alter index all on resumes rebuild
go


declare @cat varchar(255) = (select top 1 name from sys.fulltext_catalogs)
declare @sql nvarchar(max) = N'
create fulltext index on Resumes(
	Comments LANGUAGE English,
	CoverLetterText LANGUAGE English,
	TextImage LANGUAGE English
)
key index REsumesID
on ' + quotename(@cat)

exec sp_executesql @sql
go

--positions

drop index Peopleid on Positions
go

create index PeopleID on Positions(peopleid)
go

drop index ix_Positions on Positions
go

alter table Positions drop constraint PK_Positions
go

alter table Positions add constraint PK_Positions primary key clustered(PositionsID)
go

alter index all on Positions rebuild
go

--people
alter table people drop constraint [PK_People]
go

drop index lastname on people
go

alter table people add constraint pk_people primary key clustered(PeopleID)
go

create index LastName on People(LastName)
go


alter index all on People rebuild
go

--companies

alter table companies drop constraint PK_Companies
go

drop index Company on companies
go

alter table companies add constraint pk_companies primary key clustered(companiesID)
go

create index company on companies(company)
go


alter index all on companies rebuild
go