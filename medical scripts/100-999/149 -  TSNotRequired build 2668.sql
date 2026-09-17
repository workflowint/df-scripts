ALTER TABLE JobOrders add TimesheetsNotRequired bit
GO 
ALTER TABLE LinkCompaniesToRates add Specialty varchar(255) 
GO
ALTER  TABLE LinkCompaniesToRates DROP CONSTRAINT  PK_LinkCompaniesToRates
GO
CREATE UNIQUE NONCLUSTERED INDEX [LinkCompaniesToRatesUniqueInd] ON [dbo].[LinkCompaniesToRates]
(
	[RateTypesID] ASC,
	[CompaniesID] ASC,
	[Specialty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER  TABLE LinkCompaniesToRates ADD LinkCompaniesToRatesID int NOT NULL IDENTITY(1,1)
GO
ALTER TABLE LinkCompaniesToRates
    ADD CONSTRAINT PK_LinkCompaniesToRatesID PRIMARY KEY CLUSTERED (LinkCompaniesToRatesID)