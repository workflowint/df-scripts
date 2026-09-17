if exists(
	select con.*
	From sys.default_constraints con
	join sys.columns col
		on col.object_id = con.parent_object_id
		and col.column_id = con.parent_column_id
	join sys.tables t
		on t.object_id = con.parent_object_id
	where t.name = 'people'
	and col.name = 'CreatedOn'
	and con.definition like '%getutcdate()%'
)
	alter table People add constraint DF_People_UTCCreatedOn default (1) for UTCCreatedOn
go

if exists(
	select con.*
	From sys.default_constraints con
	join sys.columns col
		on col.object_id = con.parent_object_id
		and col.column_id = con.parent_column_id
	join sys.tables t
		on t.object_id = con.parent_object_id
	where t.name = 'people'
	and col.name = 'UpdatedOn'
	and con.definition like '%getutcdate()%'
)
	alter table People add constraint DF_People_UTCUpdatedOn default (1) for UTCUpdatedOn
go
