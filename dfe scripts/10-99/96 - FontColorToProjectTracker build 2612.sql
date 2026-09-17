ALTER TABLE UserList add UserPeopleID int
GO
ALTER TABLE Projects add Color int
GO
ALTER TABLE ProjectTrackerColors add FontColor int
GO
ALTER TABLE Projects DISABLE TRIGGER ProjectsUpdate
ALTER TABLE Projects DISABLE TRIGGER ProjectsAudit

UPDATE Projects set Color = FontColor where FontColor>0
UPDATE Projects set FontColor = NULL where FontColor>0

ALTER TABLE Projects ENABLE TRIGGER ProjectsUpdate
ALTER TABLE Projects ENABLE TRIGGER ProjectsAudit

