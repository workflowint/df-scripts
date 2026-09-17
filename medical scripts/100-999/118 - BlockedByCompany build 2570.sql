if ( select COUNT(*) from ActivityTypes where  TypeName ='Blocked')=0
Insert into ActivityTypes (TypeName,SearchOnly) Values('Blocked',1)
GO
if ( select COUNT(*) from ActivityTypes where TypeName ='Unblocked')=0
Insert into ActivityTypes (TypeName, SearchOnly) Values('Unblocked',1)
GO

CREATE TABLE [dbo].[BlockedByCompanies](
	[BlockedByCompaniesID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[PeopleID] [int] NULL,
	[CompaniesID] [int] NULL,
 CONSTRAINT [PK_BlockedByCompanies] PRIMARY KEY CLUSTERED 
(
	[BlockedByCompaniesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[BlockedByCompanies] ADD  CONSTRAINT [DF_BlockedByCompanies_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[BlockedByCompanies] ADD  CONSTRAINT [DF_BlockedByCompanies_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
CREATE NONCLUSTERED INDEX [BlockedByCompanies_PeopleID] ON [dbo].[BlockedByCompanies] 
(
	[PeopleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BlockedByCompanies_CompaniesID] ON [dbo].[BlockedByCompanies] 
(
	[CompaniesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[BlockedByCompanies]  TO [DeskFlowUsers]

