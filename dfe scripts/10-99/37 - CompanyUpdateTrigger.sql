/****** Object:  Trigger [dbo].[CompanyUpdate]    Script Date: 2020-03-05 1:27:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER  TRIGGER [dbo].[CompanyUpdate] ON [dbo].[Companies]
FOR UPDATE
NOT FOR REPLICATION 
AS
BEGIN
UPDATE  Companies
SET  Companies.UpdatedBy = suser_sname(),
UpdatedOn = getutcdate(), UTCUpdatedOn=1 
FROM Inserted JOIN  Companies
ON Inserted.CompaniesID =  Companies.CompaniesID

UPDATE Positions SET  Positions.CompanyName = Inserted.Company
FROM Inserted JOIN  Positions
ON Positions.CompaniesID =  Inserted.CompaniesID
WHERE Positions.CompanyName  collate sql_latin1_general_cp1_cs_as <> Inserted.Company  collate sql_latin1_general_cp1_cs_as

UPDATE Education SET Education.Institution = Inserted.Company
FROM Inserted JOIN Education
ON Education.InstitutionCompanyID = Inserted.CompaniesID
WHERE Education.Institution <> Inserted.Company

UPDATE Companies
SET  
ExchangeRate = (SELECT CurrentRate FROM ExchangeRates WITH(NOLOCK)
WHERE CurrencyUnit = Inserted.CurrencyType),
ExchangeRateDate = getutcdate(), UTCUpdatedOn=1 
FROM Inserted JOIN Companies ON
( Inserted.CompaniesID = Companies.CompaniesID
AND ( Inserted.CurrencyType <> Companies.CurrencyType
OR Inserted.CustomCurrency1 <> Companies.CustomCurrency1
OR Inserted.CustomCurrency2 <> Companies.CustomCurrency2
OR Inserted.AnnualSales <> Companies.AnnualSales
OR Inserted.CreditLimit <> Companies.CreditLimit))
END




