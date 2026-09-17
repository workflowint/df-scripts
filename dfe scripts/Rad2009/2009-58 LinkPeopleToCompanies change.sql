BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_LinkPeopleToCompanies
	(
	LinkPeopleToCompaniesID int NOT NULL IDENTITY (1, 1),
	PeopleID int NULL,
	CompaniesID int NULL,
	SinceDate smalldatetime NULL,
	ToDate smalldatetime NULL,
	TypeOfLink varchar(50) NULL,
	Comments text NULL,
	Status varchar(50) NULL,
	UpdatedOn datetime NULL,
	UpdatedBy varchar(20) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_LinkPeopleToCompanies OFF
GO
IF EXISTS(SELECT * FROM dbo.LinkPeopleToCompanies)
	 EXEC('INSERT INTO dbo.Tmp_LinkPeopleToCompanies (PeopleID, CompaniesID, SinceDate, ToDate, TypeOfLink, Comments, Status, UpdatedOn, UpdatedBy)
		SELECT PeopleID, CompaniesID, SinceDate, ToDate, TypeOfLink, Comments, Status, UpdatedOn, UpdatedBy FROM dbo.LinkPeopleToCompanies WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.LinkPeopleToCompanies
GO
EXECUTE sp_rename N'dbo.Tmp_LinkPeopleToCompanies', N'LinkPeopleToCompanies', 'OBJECT' 
GO
ALTER TABLE dbo.LinkPeopleToCompanies ADD CONSTRAINT
	PK_LinkPeopleToCompanies_1 PRIMARY KEY CLUSTERED 
	(
	LinkPeopleToCompaniesID
	) ON [PRIMARY]

GO

CREATE TRIGGER [dbo].[LinkPeopleToCompaniesUpdate] ON [dbo].[LinkPeopleToCompanies]
FOR UPDATE
AS

update LinkPeopleToCompanies set 
             LinkPeopleToCompanies.UpdatedBy = suser_sname(),
             LinkPeopleToCompanies.UpdatedOn = getdate()
FROM Inserted, LinkPeopleToCompanies
WHERE Inserted.LinkPeopleToCompaniesID = LinkPeopleToCompanies.LinkPeopleToCompaniesID

GO

COMMIT
