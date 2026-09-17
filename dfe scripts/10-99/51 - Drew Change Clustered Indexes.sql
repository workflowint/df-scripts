if object_id('sp_Drew_pkToClustered') is not null
	drop proc sp_Drew_pkToClustered
go

create proc sp_Drew_pkToClustered(@TableName varchar(255))
as

--init SQL
declare @sql nvarchar(max) = N''
declare @nl nvarchar(2) = char(13) + char(10)

--table object id
declare @ObjectID int = object_id(@TableName)
	
--clustered and pk index details
declare @ncpk varchar(255), @pkcols varchar(max), @ci varchar(255), @cicols varchar(max)

select @ncpk = case when pk.index_id = ci.index_id then null else pk.name end,
@pkcols = pkc.value, @ci = ci.name, @cicols = cic.value
from sys.tables t
left join sys.indexes pk
	on pk.object_id = t.object_id
	and pk.is_primary_key = 1
left join sys.indexes ci
	on ci.object_id = t.object_id
	and ci.type_desc = 'clustered'
outer apply(
	select stuff(
		(
			select ', ' + c.name
			+ case when ic.is_descending_key = 1 then ' desc' else '' end
			from sys.index_columns ic
			join sys.columns c
				on c.object_id = @ObjectID
				and c.column_id = ic.column_id
			where ic.object_id = @ObjectID
			and ic.index_id = pk.index_id
			order by ic.index_column_id
			for xml path(''), root('a'), type
		).value('a[1]', 'varchar(max)')
		, 1, 2, ''
	)
) pkc(value)
outer apply(
	select stuff(
		(
			select ', ' + c.name
			+ case when ic.is_descending_key = 1 then ' desc' else '' end
			from sys.index_columns ic
			join sys.columns c
				on c.object_id = @ObjectID
				and c.column_id = ic.column_id
			where ic.object_id = @ObjectID
			and ic.index_id = ci.index_id
			order by ic.index_column_id
			for xml path(''), root('a'), type
		).value('a[1]', 'varchar(max)')
		, 1, 2, ''
	)
) cic(value)
where t.object_id = @ObjectID

--if nonclustered primary key exists
if @ncpk is not null begin
	print 'nonclustered primary key found'
	
	--check for FT index
	declare @hasFTI bit = 0

	if exists(select 1 from sys.fulltext_indexes where object_id = @ObjectID)
		set @hasFTI = 1

	--drop ft index
	if @hasFTI = 1
		set @sql = @sql + @nl + 'print ''dropping fulltext index'''
		+ @nl + 'drop fulltext index on ' + @TableName
		+ @nl

	--tran, try
	set @sql = @sql + @nl + 'begin tran'
	+ @nl + 'begin try'
	
	--switch clustered to nonclustered
	if @ci is not null
		set @sql = @sql + @nl + '	print ''dropping clustered index'''
		+ @nl + '	drop index ' + @ci + ' on ' + @TableName
		+ @nl + '	print ''switching to nonclustered'''
		+ @nl + '	create index ' + @ci + ' on ' + @TableName + '(' + @cicols + ')'

	--switch pk to clustered
	set @sql = @sql + @nl + '	print ''dropping nonclustered primary key'''
	+ @nl + '	alter table ' + @TableName + ' drop constraint ' + @ncpk
	+ @nl + '	print ''switching to clustered'''
	+ @nl + '	alter table ' + @TableName + ' add constraint PK_' + @TableName + ' primary key clustered(' + @pkcols + ')'
	
	--commit, try catch, rollback
	set @sql = @sql + @nl + '	commit tran'
	+ @nl + 'end try begin catch'
	+ @nl + '	rollback tran'
	+ @nl + '	print ''indexes rolled back'''
	+ @nl + 'end catch'

	--rebuild fulltext index
	if @hasFTI = 1
		set @sql = @sql + @nl
		+ @nl + 'print ''rebuilding FT index'''
		+ @nl + 'declare @sql nvarchar(max)'
		+ @nl + 'set @sql = ''create fulltext index on ' + @TableName + '('
		+ stuff(
			(
				select ', ' + c.name 
				+ case when tc.object_id is not null then ' TYPE COLUMN ' + tc.name else '' end
				+ ' LANGUAGE English'
				from sys.fulltext_index_columns fic
				join sys.columns c
					on c.object_id = fic.object_id
					and c.column_id = fic.column_id
				left join sys.columns tc
					on tc.object_id = fic.object_id
					and tc.column_id = fic.type_column_id
				where fic.object_id = @ObjectID
				for xml path(''), root('a'), type
			).value('a[1]', 'nvarchar(max)')
			, 1, 2, ''
		)
		+ ')'
		+ @nl + 'key index '' + (select name from sys.indexes where object_id = ' + cast(@ObjectID as varchar(255)) + ' and is_primary_key = 1) + '''
		+ @nl + 'on ' + quotename((select top 1 name from sys.fulltext_catalogs)) + ''''
		+ @nl + 'exec sp_executesql @sql'
	
	--print, execute sql
	print 'Executing:'
	exec sp_executesql @sql

	print ''
	print ''
	print ''
	--print 'SQL:'
	--print @sql
end
else
	print 'primary key already clustered'

go



























set nocount on;


--primary key to clustered
DECLARE @t datetime = GETDATE()
print 'People'
exec sp_Drew_pkToClustered 'People'
print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()
print 'Positions'
exec sp_Drew_pkToClustered 'Positions'
print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()
print 'Companies'
exec sp_Drew_pkToClustered 'Companies'
print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()
print 'Resumes'
exec sp_Drew_pkToClustered 'Resumes'
print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()
print 'Addresses'
exec sp_Drew_pkToClustered 'Addresses'
print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()
print 'ActivityHistory'
exec sp_Drew_pkToClustered 'ActivityHistory'
print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()
print 'email primary people'


--EmailAddress index by Primary/People
declare @EmIC table(c varchar(255), icid int, isinc bit)

insert @EmIC(c, icid, isinc)
values('IsPrimaryAddress', 1, 0)
,('PeopleID', 2, 0)
,('Address', 3, 1)
,('AddressInvalid', 4, 1)

--EmailAddress object
declare @EmObjID int = object_id('EmailAddress')

--if index doesn't already exist
if not exists(
	select emiccount = count(1), matchingcount = count(ic.index_column_id)
	from sys.indexes i
	join @EmIC emic
		on i.object_id = @EmObjID
	left join (
		sys.index_columns ic
		join sys.columns c
			on c.object_id = @EmObjID
			and ic.object_id = @EmObjID
			and c.column_id = ic.column_id
	)
		on ic.index_id = i.index_id
		and ic.index_column_id = emic.icid
		and c.name = emic.c
	group by i.index_id
	having count(1) = count(ic.index_column_id)
)
begin
	print 'EmailAddress index by Primary/People'
	create index ix_EmailAddress_PrimaryPeople on EmailAddress(IsPrimaryAddress, PeopleID) include(Address, AddressInvalid)
end


print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go

DECLARE @t datetime = GETDATE()

print 'positions primary people'



--Positions index by Primary/People
declare @PosIC table(c varchar(255), icid int, isinc bit)

insert @PosIC(c, icid, isinc)
values('IsPrimaryPosition', 1, 0)
,('PeopleID', 2, 0)

--EmailAddress object
declare @PosObjID int = object_id('Positions')

--if index doesn't already exist
if not exists(
	select posiccount = count(1), matchingcount = count(ic.index_column_id)
	from sys.indexes i
	join @PosIC posic
		on i.object_id = @PosObjID
	left join (
		sys.index_columns ic
		join sys.columns c
			on c.object_id = @PosObjID
			and ic.object_id = @PosObjID
			and c.column_id = ic.column_id
	)
		on ic.index_id = i.index_id
		and ic.index_column_id = posic.icid
		and c.name = posic.c
	group by i.index_id
	having count(1) = count(ic.index_column_id)
)
begin
	print 'Positions index by Primary/People'
	create index ix_prim_covering on Positions(IsPrimaryPosition, PeopleID) include(PositionsID, JobOrdersID, StartDate, EndDate, Salary, JobTitle, Department, CompanyName, Grade, CompaniesID, PositionType, AddressesID)
end


print 'time: ' + cast(datediff(s, @t, getdate()) as varchar(255))
go
