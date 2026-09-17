ALTER TABLE ReportsAssigned	ALTER COLUMN ReportsData varbinary(max)
go
ALTER TABLE WorkStepsStatuses	ALTER COLUMN StatusImage varbinary(max)
go
ALTER TABLE UserExports	ALTER COLUMN Report varbinary(max)
go
ALTER TABLE EMailMsgAttachments	ALTER COLUMN FileImage varbinary(max)
go
ALTER TABLE CustomGridsData	ALTER COLUMN ColumnsData varbinary(max)
go
ALTER TABLE EMailArchive ALTER COLUMN EmailFile varbinary(max)
go

ALTER TABLE People ALTER COLUMN Photo varbinary(max)
go
ALTER TABLE ProfileImporterPeople ALTER COLUMN ProfilePDF varbinary(max)
go
ALTER TABLE ProfileImporterPeople ALTER COLUMN Photo varbinary(max)
go
ALTER TABLE ProgramData ALTER COLUMN Data varbinary(max)
go
ALTER TABLE Templates ALTER COLUMN OLETemplate varbinary(max)
go
ALTER TABLE WebLogins ALTER COLUMN Resume varbinary(max)
go
ALTER TABLE Duplicates ALTER COLUMN CoverLetter varbinary(max)
go
ALTER TABLE Duplicates ALTER COLUMN ResumeWordImage varbinary(max)
go
ALTER TABLE Reports ALTER COLUMN ParamData varbinary(max)
go
ALTER TABLE Reports ALTER COLUMN DMData varbinary(max)
go
ALTER TABLE Reports ALTER COLUMN Data varbinary(max)
go
ALTER TABLE Resumes ALTER COLUMN CoverLetter varbinary(max)
go
ALTER TABLE Resumes ALTER COLUMN WordImage  varbinary(max)
go
ALTER TABLE WebApplications ALTER COLUMN CoverLetter varbinary(max)
go
ALTER TABLE UserList ALTER COLUMN UserPrefs varbinary(max)
go
ALTER TABLE CustomFormData ALTER COLUMN FormData varbinary(max)
go
ALTER TABLE ComponentsData ALTER COLUMN ComponentData varbinary(max)
go
ALTER TABLE LanguageDictionaries ALTER COLUMN FileData varbinary(max)
go
ALTER TABLE ClientConfig ALTER COLUMN ClientWFIData varbinary(max)
go
ALTER TABLE ResumeDictionaries ALTER COLUMN TextData varbinary(max)
go

ALTER TABLE WebApplications ALTER COLUMN Resume varbinary(max)
go
ALTER TABLE ProgramData64 ALTER COLUMN Data varbinary(max)
go
