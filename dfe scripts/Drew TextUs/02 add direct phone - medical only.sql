set ansi_nulls on
set quoted_identifier on
go

-- make DirectPhone varchar(255)
declare @DirectPhoneSize int = (
    select c.max_length
    from sys.columns c
    join sys.tables t on t.object_id = c.object_id
    where t.name = 'people'
      and c.name = 'directphone'
    )

if @DirectPhoneSize < 255
  alter table People

alter column DirectPhone varchar(255)
go

-- populate ParsedPhone table with DirectLine
insert ParsedPhones (
  PeopleID
  ,PhoneCol
  ,Phone
  )
select People.PeopleID
  ,'DirectPhone'
  ,DirectPhone
from people
left join ParsedPhones existing on existing.PeopleID = people.PeopleID
  and existing.PhoneCol = 'DirectPhone'
where DirectPhone is not null
  and existing.id is null

update ParsedPhones
set CountryCode = p.CountryCode
  ,PhoneNumeric = p.PhoneNumeric
from ParsedPhones
outer apply dbo.fn_Drew_ParsePhone_t(ParsedPhones.Phone) p
where ParsedPhones.PhoneCol = 'DirectPhone'
go

/*============================================================
================= trigger ====================================
============================================================*/
if object_id('People_IUD_ParsePhones') is not null
  drop trigger People_IUD_ParsePhones
go

create trigger People_IUD_ParsePhones on People
for insert
  ,update
  ,delete
as
begin
  declare @Operation varchar(255)

  set @Operation = case 
      when (
          select count(1)
          from inserted
          ) > 0
        then case 
            when (
                select count(1)
                from deleted
                ) > 0
              then 'update'
            else 'insert'
            end
      else 'delete'
      end

  if @Operation in (
      'insert'
      ,'update'
      )
  begin
    -- create non-existing
    insert ParsedPhones (
      PeopleID
      ,PhoneCol
      )
    select inserted.PeopleID
      ,PhoneCols.PhoneCol
    from inserted
    cross join (
      select 'Phone1'
      
      union all
      
      select 'Phone2'
      
      union all
      
      select 'Phone3'
      
      union all
      
      select 'Phone4'
      
      union all
      
      select 'Phone5'
      
      union all
      
      select 'Phone6'
      
      union all
      
      select 'DirectPhone'
      ) PhoneCols(PhoneCol)
    left join ParsedPhones existing on existing.PeopleID = inserted.Peopleid
      and existing.PhoneCol = PhoneCols.PhoneCol
    where existing.id is null

    --parse
    update ParsedPhones
    set Phone = upvt.Phone
      ,CountryCode = p.CountryCode
      ,PhoneNumeric = p.PhoneNumeric
    from (
      select inserted.PeopleID
        ,Phone1 = cast(inserted.Phone1 as varchar(255))
        ,Phone2 = cast(inserted.Phone2 as varchar(255))
        ,Phone3 = cast(inserted.Phone3 as varchar(255))
        ,Phone4 = cast(inserted.Phone4 as varchar(255))
        ,Phone5 = cast(inserted.Phone5 as varchar(255))
        ,Phone6 = cast(inserted.Phone6 as varchar(255))
        ,DirectPhone = cast(inserted.DirectPhone as varchar(255))
      from inserted
      left join deleted on deleted.PeopleID = inserted.PeopleID
      where isnull(inserted.Phone1, '') <> isnull(deleted.Phone1, '')
        or isnull(inserted.Phone2, '') <> isnull(deleted.Phone2, '')
        or isnull(inserted.Phone3, '') <> isnull(deleted.Phone3, '')
        or isnull(inserted.Phone4, '') <> isnull(deleted.Phone4, '')
        or isnull(inserted.Phone5, '') <> isnull(deleted.Phone5, '')
        or isnull(inserted.Phone6, '') <> isnull(deleted.Phone6, '')
        or isnull(inserted.DirectPhone, '') <> isnull(deleted.DirectPhone, '')
      ) changed
    unpivot(Phone for PhoneCol in (
          [Phone1]
          ,[Phone2]
          ,[Phone3]
          ,[Phone4]
          ,[Phone5]
          ,[Phone6]
          ,[DirectPhone]
          )) upvt
    join ParsedPhones on ParsedPhones.PeopleID = upvt.[PeopleID]
      and ParsedPhones.PhoneCol = upvt.PhoneCol
    outer apply dbo.fn_Drew_ParsePhone_t(upvt.Phone) p
  end

  if @Operation = 'delete'
    delete ParsedPhones
    from deleted
    join ParsedPhones on ParsedPhones.PeopleID = deleted.PeopleID
end
go

/*================================================================*/
