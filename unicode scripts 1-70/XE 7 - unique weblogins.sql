ALTER TABLE WebLogins
ADD UNIQUE (LoginName)
GO
ALTER TABLE Duplicates
ALTER COLUMN DuplicateIDs varchar(MAX)
GO
ALTER TABLE LinkOpportunitiesToBusinessObjects add  NewOpportunitiesID int