set ansi_nulls on
set quoted_identifier on
go

update LookupTables
set Visible = Visible + ',Mileage'
  ,Editable = Editable + ',Mileage'
from LookupTables
where Name = 'ExpenseCategories'

update ExpenseCategories
set Mileage = 1
where ExpenseDescription like '%mileage%'
