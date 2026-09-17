ALTER TABLE People add BlockDup bit
go
ALTER TABLE People  DISABLE TRIGGER PeopleAudit
ALTER TABLE People  DISABLE TRIGGER PeopleUpdate
ALTER TABLE People  DISABLE TRIGGER PeopleUpdateWebLogin

UPDATE People set BlockDup = 1  where Block='1'

ALTER TABLE People  ENABLE TRIGGER PeopleAudit
ALTER TABLE People  ENABLE TRIGGER PeopleUpdate
ALTER TABLE People  ENABLE TRIGGER PeopleUpdateWebLogin
GO
ALTER TABLE Positions add TravelComplete bit
GO
ALTER TABLE LinkPeopleToSources add DefaultSource bit
GO
ALTER TABLE ClientConfig add CreateTravelForNewPosition bit
GO
UPDATE LinkPeopleToSources
set DefaultSource=1
WHERE PeopleID > 0 and PeopleID IN
( SELECT PeopleID from LinkPeopleToSources GROUP BY PeopleID Having count(*)=1)
AND IsNULL(DefaultSource,0)=0
