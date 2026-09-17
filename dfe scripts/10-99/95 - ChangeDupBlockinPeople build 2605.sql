ALTER TABLE People add BlockDup bit
go
ALTER TABLE People  DISABLE TRIGGER PeopleAudit
ALTER TABLE People  DISABLE TRIGGER PeopleUpdate
ALTER TABLE People  DISABLE TRIGGER PeopleUpdateWebLogin

UPDATE People set BlockDup = 1  where Block=1

ALTER TABLE People  ENABLE TRIGGER PeopleAudit
ALTER TABLE People  ENABLE TRIGGER PeopleUpdate
ALTER TABLE People  ENABLE TRIGGER PeopleUpdateWebLogin
