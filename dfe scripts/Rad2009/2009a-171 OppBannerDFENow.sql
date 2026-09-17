ALTER TABLE ClientConfig add OppBannerLine varchar(max)
GO
ALTER TABLE ProjectsClientTeams
     ADD DFENowEnabled BIT NULL
GO
ALTER TABLE Projects
     ADD DFENowEnabled BIT NULL
GO
ALTER TABLE ActivityTypes
     ADD ShowInDFENow BIT NULL
GO

ALTER TABLE Worklists
     ADD ShowInDFENow BIT NULL