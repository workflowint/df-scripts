ALTER TABLE ClientConfig
ADD [CurrentPosBlock] [bit] NULL DEFAULT (0)

GO

UPDATE ClientConfig SET CurrentPosBlock = 0

GO

CREATE FUNCTION [dbo].[BLOKINFO](@PeopleID int, @USE_ENH_BLOCK int )
RETURNS @CompanyBlockInfo TABLE (
   Block  int   , BDate datetime, NCname varchar(255), ClientEmployee int
) 
AS
BEGIN

	IF @USE_ENH_BLOCK > 0
		insert into @CompanyBlockInfo ( Block, BDate, NCname, ClientEmployee)
		SELECT TOP 1 C1.Block, C1.BlockUntilDate, C1.Company, ClientEmployee = C1.Block 
		FROM Positions P1 LEFT JOIN Companies C1 ON (P1.CompaniesID = C1.CompaniesID)  
		WHERE ( C1.Block = 1 or (dbo.fn_GetCompanyBlock(P1.CompaniesID,P1.AddressesID,P1.RoleCode1,P1.RoleCode2,C1.Block ) > 0) ) and P1.PeopleID = @PeopleID and IsNull(P1.Enddate,getdate() + 1) > getdate()  
		ORDER BY C1.BlockUntilDate DESC 
	ELSE
		insert into @CompanyBlockInfo ( Block, BDate, NCname, ClientEmployee)
		SELECT TOP 1 C1.Block, C1.BlockUntilDate, C1.Company, ClientEmployee = C1.Block 
		FROM Positions P1 LEFT JOIN Companies C1 ON (P1.CompaniesID = C1.CompaniesID)  
		WHERE C1.Block > 0 and P1.PeopleID = @PeopleID and IsNull(P1.Enddate,getdate() + 1) > getdate()  
		ORDER BY C1.BlockUntilDate DESC 	

	RETURN
END

GO

GRANT  SELECT ON [dbo].[BLOKINFO]  TO [DeskFlowUsers]

GO
