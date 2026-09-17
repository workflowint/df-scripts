IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Contacts_Block]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[People] DROP CONSTRAINT [DF_Contacts_Block]
END
GO
ALTER TABLE People ALTER COLUMN block char(1)
GO
ALTER TABLE People DISABLE Trigger PeopleUpdate
ALTER TABLE People DISABLE Trigger PeopleAudit
ALTER TABLE People DISABLE Trigger PeopleUpdateWebLogin

Update People set Block = NULL where Block = '0'
Update People set Block = 'Y' where Block = '1'

ALTER TABLE People ENABLE Trigger PeopleUpdate
ALTER TABLE People ENABLE Trigger PeopleAudit
ALTER TABLE People ENABLE Trigger PeopleUpdateWebLogin

