drop function blokinfo
go

create FUNCTION [dbo].[BLOKINFO](@PeopleID int, @USE_ENH_BLOCK int )
RETURNS @CompanyBlockInfo TABLE (
   Block  int   , BDate datetime, NCname varchar(255), ClientEmployee int
) 
AS
BEGIN

	IF @USE_ENH_BLOCK > 0
		insert into @CompanyBlockInfo ( Block, BDate, NCname, ClientEmployee)
		SELECT TOP 1 CB1.Block, CB1.BDate, C1.Company, ClientEmployee = 1 
		FROM Positions P1 WITH(NOLOCK) LEFT JOIN Companies C1 with(nolock) ON (P1.CompaniesID = C1.CompaniesID)  
		OUTER APPLY COMPBLOCKINFO( P1.PositionsID ) AS CB1
		WHERE ( CB1.Block > 0 and P1.PeopleID = @PeopleID and IsNull(P1.Enddate,getdate() + 1) > getdate() )  
		ORDER BY CB1.BDate DESC 
	ELSE
		insert into @CompanyBlockInfo ( Block, BDate, NCname, ClientEmployee)
		SELECT TOP 1 C1.Block, C1.BlockUntilDate, C1.Company, ClientEmployee = 1 
		FROM Positions P1 WITH(NOLOCK) LEFT JOIN Companies C1 WITH(NOLOCK) ON (P1.CompaniesID = C1.CompaniesID)  
		WHERE C1.Block > 0 and P1.PeopleID = @PeopleID and IsNull(P1.Enddate,getdate() + 1) > getdate()  
		ORDER BY C1.BlockUntilDate DESC 	

	RETURN
END
go

grant select on blokinfo to DeskflowUsers
go