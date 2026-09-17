set ansi_nulls on
go
set quoted_identifier on
go

-- idlist type
if exists(select 1
from sys.types
where name = 'idlist')
  drop type idlist
go
create type idlist as table(id int primary key)
go

