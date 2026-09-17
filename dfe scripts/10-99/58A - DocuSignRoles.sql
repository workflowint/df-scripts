SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocuSignRoles](
	[DocuSignRolesID] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](50) NULL,
	[SignatureTag] [varchar](100) NULL,
	[InitialTag] [varchar](100) NULL,
	[DateTag] [varchar](100) NULL,
	[TextTag]  [varchar] (100) NULL,
 CONSTRAINT [PK_DocuSignRoles] PRIMARY KEY CLUSTERED 
(
	[DocuSignRolesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DocuSignRoles_Role] ON [dbo].[DocuSignRoles]
(
	[Role] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DocuSignRoles] TO [DeskFlowUsers]
GO
if ( select count(*) from LookupTables where Name='DocuSignRoles')=0
Insert into LookupTables (Name,Description,Editable,Visible,CanDelete)
values ('DocuSignRoles', 'DocuSign Roles','Role,SignatureTag,InitialTag,DateTag,TextTag','Role,SignatureTag,InitialTag,DateTag,TextTag',1)
