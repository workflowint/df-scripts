update ExcelMapping set RecNumber=1 where tablename = 'ActivityHistory' and IsNull(RecNumber,0)=0
update ExcelMapping set FieldLabel=FieldLabel+'(1)' where tablename = 'ActivityHistory'
and FieldLabel not like '%(_)'
