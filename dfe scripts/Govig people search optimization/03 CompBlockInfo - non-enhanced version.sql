SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[COMPBLOCKINFO](@PositionsID int)
RETURNS TABLE
AS RETURN
	SELECT Block = Companies.Block, BDate = Companies.BlockUntilDate, Company = Companies.Company, ClientEmployee = 1, BlockedBy = Companies.BlockedBy, BlockNotes = Companies.BlockNotes
	FROM Positions WITH(NOLOCK)
	JOIN Companies WITH(NOLOCK)
		ON Companies.CompaniesID = Positions.CompaniesID
	WHERE Positions.PositionsID = @PositionsID
	AND (Positions.EndDate IS NULL OR Positions.EndDate > GETDATE())
	AND (Companies.BlockUntilDate IS NULL OR Companies.BlockUntilDate > GETDATE())
	AND Companies.Block > 0

GO


