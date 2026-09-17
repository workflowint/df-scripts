
--drop
if object_id('sp_SearchPhoneNumeric') is not null
	drop proc sp_SearchPhoneNumeric
go

--create proc
create proc sp_SearchPhoneNumeric(@Phone varchar(255))
as begin

--intersperse phone number with wildcards
declare @WildcardPhone varchar(511) = '%'

declare @i int = 1

while @i <= len(@Phone) begin
	set @WildcardPhone = @WildcardPhone + SUBSTRING(@Phone, @i, 1) + '%'
	set @i = @i + 1
end

--search
SELECT PeopleID, CustomText5 
FROM People WITH(NOLOCK) 
WHERE  ( 
	( LEFT(Phone1,20) LIKE @WildcardPhone OR Phone1 = @Phone ) and Phone1 NOT LIKE 'http%' )  
	OR  ( ( LEFT(Phone2,20) LIKE @WildcardPhone OR Phone2 = @Phone ) and Phone2 NOT LIKE 'http%' )  
	OR  ( ( LEFT(Phone3,20) LIKE @WildcardPhone OR Phone3 = @Phone ) and Phone3 NOT LIKE 'http%' )  
	OR  ( ( LEFT(Phone4,20) LIKE @WildcardPhone OR Phone4 = @Phone ) and Phone4 NOT LIKE 'http%' )  
	OR  ( ( LEFT(Phone5,20) LIKE @WildcardPhone OR Phone5 = @Phone ) and Phone5 NOT LIKE 'http%' )  
	OR  ( ( LEFT(Phone6,20) LIKE @WildcardPhone OR Phone6 = @Phone ) and Phone6 NOT LIKE 'http%' ) 
end
go

--permissions
grant execute on sp_SearchPhoneNumeric to DeskflowUsers
go

--test
exec sp_SearchPhoneNumeric '9876543210'