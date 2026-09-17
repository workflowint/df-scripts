ALTER TABLE Document add DocuSignStatus int
GO
ALTER TABLE MedApplications add AppType varchar(50)
GO
CREATE TABLE [dbo].[MedApplicationType](
	[MedApplicationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_MedApplicationType] PRIMARY KEY CLUSTERED 
(
	[MedApplicationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[MedApplicationType] TO [DeskFlowUsers]
GO
if ( select count(*) from LookupTables where Name='MedApplicationType')=0
Insert into LookupTables (Name,Description,Editable,Visible,CanDelete)
values ('MedApplicationType', 'Med Application Type','Description','Description',1)

