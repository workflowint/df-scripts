ALTER TABLE LinkWebApplicantsToSkills
ADD IsPreference [bit] NULL

GO

ALTER TABLE DuplicatesSkills
ADD IsPreference [bit] NULL

GO

ALTER TABLE WebApplications
ADD ApplicationType varchar(255) NULL,
DefaultPhone varchar(255) NULL

GO

ALTER TABLE Duplicates
ADD AHNotes text NULL,
ApplicationType varchar(255) NULL,
DefaultPhone varchar(255) NULL

GO 

ALTER TABLE PeopleAppliedTo
ADD ApplicationType int NULL