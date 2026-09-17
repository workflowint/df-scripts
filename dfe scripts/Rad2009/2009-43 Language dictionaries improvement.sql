ALTER TABLE dbo.LanguageDictionaries ADD CONSTRAINT
	DF_LanguageDictionaries_CreatedBy DEFAULT suser_sname() FOR CreatedBy
GO

ALTER TABLE dbo.LanguageDictionaries ADD
	UpdatedOn datetime NULL,
	UpdatedBy varchar(50) NULL
GO
ALTER TABLE dbo.LanguageDictionaries ADD CONSTRAINT
	DF_LanguageDictionaries_UpdatedOn DEFAULT getdate() FOR UpdatedOn
GO
ALTER TABLE dbo.LanguageDictionaries ADD CONSTRAINT
	DF_LanguageDictionaries_UpdatedBy DEFAULT suser_sname() FOR UpdatedBy
GO

CREATE  TRIGGER LanguageDictionariesUpdate ON dbo.LanguageDictionaries
FOR UPDATE
NOT FOR REPLICATION 
AS
BEGIN
UPDATE  LanguageDictionaries
SET  LanguageDictionaries.UpdatedBy = suser_sname(),
LanguageDictionaries.UpdatedOn = GETDATE()
FROM Inserted,  LanguageDictionaries
WHERE Inserted.LanguageDictionariesID =  LanguageDictionaries.LanguageDictionariesID
END

GO