ALTER TABLE CandidateReferences add ReferenceType varchar(50)
GO
CREATE TABLE [dbo].[ReferenceType](
	[ReferenceTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceType] [varchar](50) NULL,
 CONSTRAINT [PK_ReferenceTypeID] PRIMARY KEY CLUSTERED 
(
	[ReferenceTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ReferenceType]  TO [DeskFlowUsers]
GO
if ( select COUNT(*) from LookupTables where Name='ReferenceType')=0
insert into LookupTables(Name,Description,Editable,Visible,CanDelete)
values ( 'ReferenceType','Reference Type','ReferenceType','ReferenceType',1)
GO
CREATE NONCLUSTERED INDEX [IX_CompaniesBlock_CompaniesID] ON [dbo].[CompaniesBlock] 
(
	[CompaniesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

