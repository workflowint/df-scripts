CREATE TABLE Integrations(
	IntegrationsID int IDENTITY(1,1) NOT NULL,
	Description varchar(50) NULL,
 CONSTRAINT [PK_IntegrationsID] PRIMARY KEY CLUSTERED 
(
	[IntegrationsID] ASC
))
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Integrations]  TO [DeskFlowUsers]
GO
CREATE TABLE PeopleIntegrations(
	PeopleIntegrationsID int IDENTITY(1,1) NOT NULL,
	Integration varchar(100) NOT NULL,
	IntegrationCode varchar(100) NOT NULL,
	PeopleID int NOT NULL, 
 CONSTRAINT [PK_PeopleIntegrationsID] PRIMARY KEY CLUSTERED 
(
	[PeopleIntegrationsID] ASC
))
GO
CREATE NONCLUSTERED INDEX [PeopleIntegrations_PeopleID] ON [dbo].[PeopleIntegrations]
(
	[PeopleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniquePeopleIntegrationsIndex] ON [dbo].[PeopleIntegrations]
(
	[Integration] ASC,
	[IntegrationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PeopleIntegrations]  TO [DeskFlowUsers]
GO
CREATE TABLE CompaniesIntegrations(
	CompaniesIntegrationsID int IDENTITY(1,1) NOT NULL,
	Integration varchar(100) NOT NULL,
	IntegrationCode varchar(100) NOT NULL,
	CompaniesID int NOT NULL, 
 CONSTRAINT [PK_CompaniesIntegrationsID] PRIMARY KEY CLUSTERED 
(
	[CompaniesIntegrationsID] ASC
))
GO
CREATE NONCLUSTERED INDEX [CompaniesIntegrations_PeopleID] ON [dbo].[CompaniesIntegrations]
(
	[CompaniesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UniqueCompaniesIntegrationsIndex] ON [dbo].[CompaniesIntegrations]
(
	[Integration] ASC,
	[IntegrationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CompaniesIntegrations]  TO [DeskFlowUsers]
GO

