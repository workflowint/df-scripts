SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LinkWebApplicantsToDocument](
	[LinkWebApplicantsToDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[WebApplicantsID] [int] NULL,
	[Document] [image] NULL,
	[DocName] [varchar](255) NULL,
 CONSTRAINT [PK_LinkWebApplicantsToDocument] PRIMARY KEY NONCLUSTERED 
(
	[LinkWebApplicantsToDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkWebApplicantsToDocument] TO [DeskFlowUsers]

GO

CREATE TABLE [dbo].[DuplicatesDocument](
	[DuplicatesDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[DuplicatesID] [int] NULL,
	[Document] [image] NULL,
	[DocName] [varchar](255) NULL,
 CONSTRAINT [PK_DuplicatesDocument] PRIMARY KEY NONCLUSTERED 
(
	[DuplicatesDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DuplicatesDocument] TO [DeskFlowUsers]

GO

ALTER TRIGGER [dbo].[DuplicatesDelete] ON [dbo].[Duplicates]  
FOR DELETE   
AS  
---------------------------------------------------------------------------------------------------
DELETE FROM DuplicatesEducation WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)
DELETE FROM DuplicatesSkills WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)
DELETE FROM DuplicatesDocument WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)
DELETE FROM LinkAnswersToDuplicates WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)

GO

ALTER TRIGGER [dbo].[WebApplicationsDelete] ON [dbo].[WebApplications]   
  
FOR DELETE   
  
AS  
delete from Answers     where WebApplicationsID IN(SELECT WebApplicationsID FROM deleted)
delete from LinkWebApplicantsToSkills where WebApplicantsID IN(SELECT WebApplicationsID FROM deleted) 
delete from LinkWebApplicantsToDocument where WebApplicantsID IN(SELECT WebApplicationsID FROM deleted) 

GO

ALTER TABLE ResumeJinniConfig
ADD [AdditionalDocCategoryID] [int] NULL,
 [SendInternalMessage] [bit] NOT NULL DEFAULT(0)

GO

ALTER TABLE Projects
ADD [InternalTemplateID] [int] NULL,
	[InternalSubject] [varchar](255) NULL,
	[InternalFormat] [int] NULL

GO	

ALTER TABLE ResumeJinniConfig
ADD [InternalTemplateID] [int] NULL,
	[InternalSubject] [varchar](255) NULL,
	[InternalFormat] [int] NULL
	
GO

