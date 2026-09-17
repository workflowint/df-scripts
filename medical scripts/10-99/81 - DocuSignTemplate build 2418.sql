ALTER TABLE Document add TemplatesID int
GO
CREATE TABLE [dbo].[TemplateDocusignRoles](
	[TemplateDocusignRolesID] [int] IDENTITY(1,1) NOT NULL,
	[TemplatesID] [int] NULL,
	[DocusignRole] [varchar](50) NULL,
	[DocusignType] [varchar](50) NULL,
 CONSTRAINT [PK_TemplateDocusignRoles] PRIMARY KEY CLUSTERED 
(
	[TemplateDocusignRolesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE   TRIGGER [dbo].[DeleteTemplates] ON [dbo].[Templates]
FOR  DELETE 
AS
delete from TemplateDocusignRoles where
TemplatesID in ( select TemplatesID from Deleted)
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[TemplateDocusignRoles]  TO [DeskFlowUsers]

