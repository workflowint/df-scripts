ALTER TABLE WebApplications add CoverLetter image,CoverLetterName varchar(255)
go
ALTER TABLE Resumes add CoverLetter image,CoverLetterText varchar(max),CoverLetterName varchar(255),CoverLetterExt varchar(10)
go
ALTER TABLE Duplicates add CoverLetter image,CoverLetterText varchar(max),CoverLetterName varchar(255)
go
ALTER TABLE Duplicates add CoverLetterExt varchar(10)
go
CREATE FULLTEXT INDEX on Resumes (CoverLetterText) KEY index ResumesID