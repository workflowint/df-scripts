
--drop
if object_id('sp_SearchPhoneNumeric') is not null
	drop proc sp_SearchPhoneNumeric
go

--create proc
create proc sp_SearchPhoneNumeric(@Phone varchar(255))
as begin

select distinct People.PeopleID, People.CustomText5
from People
join ParsedPhones
	on ParsedPhones.PeopleID = People.PeopleID
where ParsedPhones.PhoneNumeric like @Phone + '%'

end
go

--permissions
grant execute on sp_SearchPhoneNumeric to DeskflowUsers
go

--test
exec sp_SearchPhoneNumeric '9876543210'