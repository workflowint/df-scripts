create table StandardMileageRate (
  id int identity primary key
  ,FromDateYmd varchar(31)
  ,ToDateYmd varchar(31)
  ,Rate money
  )
go

grant select
  ,insert
  ,update
  ,delete
  on StandardMileageRate
  to DeskflowUsers
go

insert StandardMileageRate (
  FromDateYmd
  ,ToDateYmd
  ,Rate
  )
values (
  '2023-01-01'
  ,'2023-12-31'
  ,.655
  )

insert LookupTables (
  Name
  ,Description
  ,Editable
  ,Visible
  ,CanDelete
  )
values (
  'StandardMileageRate'
  ,'Default mileage expense rate'
  ,'FromDateYmd,ToDateYmd,Rate'
  ,'FromDateYmd,ToDateYmd,Rate'
  ,1
  )
