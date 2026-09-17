if not exists(select * from sys.indexes where name = 'ix_mdc_trifecta')
	CREATE NONCLUSTERED INDEX [ix_mdc_trifecta] ON [dbo].[MonitorDataChanges]
	(
		[ChangedTableName] ASC,
		[ChangedFieldName] ASC,
		[NewValue] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


