ALTER TABLE WebLogins
ADD Photo varbinary(MAX) NULL,
	Gender varchar(1) NULL,
	Birthday datetime NULL
	
GO

ALTER TABLE WebApplications
ADD Photo varbinary(MAX) NULL

GO

ALTER TABLE Duplicates
ADD Photo varbinary(MAX) NULL

GO
