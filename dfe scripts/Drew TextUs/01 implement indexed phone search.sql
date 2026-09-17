

BEGIN TRY DROP FUNCTION fn_Drew_IntCharsOnly END TRY BEGIN CATCH END CATCH
GO

CREATE FUNCTION [dbo].[fn_Drew_IntCharsOnly](@Input varchar(max))
RETURNS varchar(max)
as begin

declare @Result varchar(max) = '';
declare @i int = 1

while @i <= len(@Input) begin
	declare @Char varchar(1) = substring(@Input, @i, 1)
	if @Char like '[0-9]'
		set @Result = @Result + @Char
	set @i = @i + 1
end

RETURN nullif(@Result, '')

end

GO

GRANT EXECUTE ON fn_Drew_IntCharsOnly TO DeskflowUsers

go

/*------------------------------------------------------------*/

--drop fn
if object_id('fn_Drew_ParsePhone_t') is not null
	drop function fn_Drew_ParsePhone_t
go

--create fn
create function fn_Drew_ParsePhone_t(@Phone varchar(255))
returns @Parsed table(CountryCode varchar(255), PhoneNumeric varchar(255))
as begin
	declare @CC varchar(255)
	declare @PN varchar(255)

	if @Phone not like 'http%'
		set @PN = dbo.fn_Drew_IntCharsOnly(@Phone)

	if @PN like '1%'
	begin
		set @CC = '1'
		set @PN = stuff(@PN, 1, 1, '')
	end

	insert @Parsed(CountryCode, PhoneNumeric)
	values(@CC, @PN)

	return
end
go

--permissions
grant select on fn_Drew_ParsePhone_t to DeskflowUsers
go

/*------------------------------------------------------------*/

--drop table
if OBJECT_ID('ParsedPhones') is not null
	drop table ParsedPhones
go

--create table
create table ParsedPhones(id int identity primary key, PeopleID int not null, PhoneCol varchar(255) not null, Phone varchar(255), CountryCode varchar(255), PhoneNumeric varchar(255))
go

--permissions
grant select, insert, update, delete on ParsedPhones to DeskflowUsers
go

--index
alter table ParsedPhones add constraint uq_peoplePhoneCol unique(PeopleID, PhoneCol)
create index ix_Phone on ParsedPhones(Phone)
create index ix_PhoneNumeric on ParsedPhones(PhoneNumeric)
go

--populate
insert ParsedPhones(PeopleID, PhoneCol, Phone)
select upvt.PeopleID, upvt.PhoneType, upvt.PhoneNumber
from people
unpivot(
	PhoneNumber for PhoneType in([Phone1], [Phone2], [Phone3], [Phone4], [Phone5], [Phone6])
) upvt

--parse
update ParsedPhones
set CountryCode = p.CountryCode, PhoneNumeric = p.PhoneNumeric
from ParsedPhones
outer apply dbo.fn_Drew_ParsePhone_t(ParsedPhones.Phone) p
go


/*------------------------------------------------------------*/

--drop
if object_id('People_IUD_ParsePhones') is not null
	drop trigger People_IUD_ParsePhones
go

--create trigger
create trigger People_IUD_ParsePhones
on People
for insert, update, delete
as begin
	
	--determine operation
	declare @Operation varchar(255)
	set @Operation = case
		when (select count(1) from inserted) > 0 then
			case when (select count(1) from deleted) > 0 then 'update'
			else 'insert'
			end
		else 'delete'
		end

	--for insert/update
	if @Operation in('insert', 'update')
	begin
		--create non-existing
		insert ParsedPhones(PeopleID, PhoneCol)
		select inserted.PeopleID, PhoneCols.PhoneCol
		from inserted
		cross join(
			select 'Phone1'
			union all select 'Phone2'
			union all select 'Phone3'
			union all select 'Phone4'
			union all select 'Phone5'
			union all select 'Phone6'
		) PhoneCols(PhoneCol)
		left join ParsedPhones existing
			on existing.PeopleID = inserted.Peopleid
			and existing.PhoneCol = PhoneCols.PhoneCol
		where existing.id is null

		--parse
		update ParsedPhones
		set Phone = upvt.Phone, CountryCode = p.CountryCode, PhoneNumeric = p.PhoneNumeric
		from (
			select inserted.PeopleID, inserted.Phone1, inserted.Phone2, inserted.Phone3, inserted.Phone4, inserted.Phone5, inserted.Phone6
			from inserted
			left join deleted
				on deleted.PeopleID = inserted.PeopleID
			where isnull(inserted.Phone1, '') <> isnull(deleted.Phone1, '')
			or isnull(inserted.Phone2, '') <> isnull(deleted.Phone2, '')
			or isnull(inserted.Phone3, '') <> isnull(deleted.Phone3, '')
			or isnull(inserted.Phone4, '') <> isnull(deleted.Phone4, '')
			or isnull(inserted.Phone5, '') <> isnull(deleted.Phone5, '')
			or isnull(inserted.Phone6, '') <> isnull(deleted.Phone6, '')
		)	changed
		unpivot (
			Phone for PhoneCol in([Phone1], [Phone2], [Phone3], [Phone4], [Phone5], [Phone6])
		) upvt
		join ParsedPhones
			on ParsedPhones.PeopleID = upvt.[PeopleID]
			and ParsedPhones.PhoneCol = upvt.PhoneCol
		outer apply dbo.fn_Drew_ParsePhone_t(upvt.Phone) p
	end

	--for delete
	if @Operation = 'delete'
		delete ParsedPhones
		from deleted
		join ParsedPhones
			on ParsedPhones.PeopleID = deleted.PeopleID
end
go

/*------------------------------------------------------------*/


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
