/****** Object:  Table [dbo].[MajorName]    Script Date: 08/20/2014 13:39:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MajorName](
	[MajorNameID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_MajorName] PRIMARY KEY CLUSTERED 
(
	[MajorNameID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[MajorName]  TO [DeskFlowUsers]

GO

IF ( select count(*) from LookupTables where Name = 'MajorName' )=0
INSERT INTO LookupTables (Name, Description, Editable, Visible)
VALUES ('MajorName', 'Major Type in PEOPLE Education tab', 'Description', 'Description' )

GO

ALTER TABLE Education
ADD InstitutionCompanyID [int] NULL

GO
/****** Object:  Trigger [dbo].[CompanyUpdate]    Script Date: 08/20/2014 14:42:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[CompanyUpdate] ON [dbo].[Companies]
FOR UPDATE
NOT FOR REPLICATION 
AS
BEGIN
UPDATE  Companies
SET  Companies.UpdatedBy = suser_sname(),
UpdatedOn = GETDATE()
FROM Inserted,  Companies
WHERE Inserted.CompaniesID =  Companies.CompaniesID

UPDATE Positions SET  Positions.CompanyName = Inserted.Company
FROM Inserted,  Positions
WHERE Positions.CompaniesID =  Inserted.CompaniesID
AND Positions.CompanyName <> Inserted.Company

UPDATE Education SET Education.Institution = Inserted.Company
FROM Inserted, Education
WHERE Education.InstitutionCompanyID = Inserted.CompaniesID
AND Education.Institution <> Inserted.Company

UPDATE Companies
SET  
ExchangeRate = (SELECT CurrentRate FROM ExchangeRates WITH(NOLOCK)
WHERE CurrencyUnit = Inserted.CurrencyType),
ExchangeRateDate = GETDATE()
FROM Inserted JOIN Companies ON
( Inserted.CompaniesID = Companies.CompaniesID
AND ( Inserted.CurrencyType <> Companies.CurrencyType
OR Inserted.CustomCurrency1 <> Companies.CustomCurrency1
OR Inserted.CustomCurrency2 <> Companies.CustomCurrency2
OR Inserted.AnnualSales <> Companies.AnnualSales
OR Inserted.CreditLimit <> Companies.CreditLimit))
END




