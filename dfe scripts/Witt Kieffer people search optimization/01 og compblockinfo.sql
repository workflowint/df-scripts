drop function COMPBLOCKINFO
go

create FUNCTION [dbo].[COMPBLOCKINFO](@PositionsID int )
RETURNS @CompanyBlockInfo TABLE (
   Block  int, BDate datetime, Company varchar(255), ClientEmployee int, BlockedBy varchar(20), BlockNotes text
) 
AS
BEGIN

 DECLARE @ENH_BLOCK int  
 SELECT TOP 1 @ENH_BLOCK = EnhancedCompanyBlock FROM ClientConfig WITH(NOLOCK)  
 
 IF @ENH_BLOCK > 0 
	 insert into @CompanyBlockInfo ( Block, BDate, Company, ClientEmployee, BlockedBy, BlockNotes )
	 SELECT TOP 1 CB1.Block, CB1.BlockUntilDate, C1.Company, ClientEmployee = 1, CB1.BlockedBy, CB1.BlockNotes
	 FROM Positions P1 WITH(NOLOCK)
		LEFT JOIN Companies C1 WITH(NOLOCK) ON (P1.CompaniesID = C1.CompaniesID)
		LEFT JOIN CompaniesBlock CB1 WITH(NOLOCK) ON (CB1.CompaniesID = C1.CompaniesID)
	 WHERE ( (IsNull(CB1.Block,0) = 1 or (dbo.fn_GetCompanyBlockForPosition(P1.CompaniesID, P1.PositionsID, CB1.ProjectsID) > 0 )) and IsNull(CB1.BlockUntilDate,getdate() + 1) > getdate() and P1.PositionsID = @PositionsID )
	 ORDER BY CB1.UpdatedOn DESC
 ELSE
	 insert into @CompanyBlockInfo ( Block, BDate, Company, ClientEmployee, BlockedBy, BlockNotes )
	 SELECT TOP 1 C1.Block, C1.BlockUntilDate, C1.Company, ClientEmployee = 1, C1.BlockedBy, C1.BlockNotes
	 FROM Positions P1 WITH(NOLOCK)
		LEFT JOIN Companies C1 WITH(NOLOCK) ON (P1.CompaniesID = C1.CompaniesID)
	 WHERE ( IsNull(C1.Block,0) > 0 and IsNull(C1.BlockUntilDate,getdate() + 1) > getdate() and P1.PositionsID = @PositionsID )
 RETURN
 
END
go

grant select on compblockinfo to DeskflowUsers
go