CREATE INDEX ix_LinkPeopleToSkills_PositionSkillSkillcategory ON LinkPeopleToSkills(PositionsID, SkillsID, SkillCategoryID)
GO

BEGIN TRY DROP FUNCTION BLOKINFO END TRY BEGIN CATCH END CATCH
GO
BEGIN TRY DROP FUNCTION COMPBLOCKINFO END TRY BEGIN CATCH END CATCH
GO

CREATE FUNCTION COMPBLOCKINFO(@PositionsID int)
RETURNS TABLE
AS RETURN
	SELECT Block = BlockForPos.Block, BDate = BlockForPos.BlockUntilDate, Company = Companies.Company, ClientEmployee = 1, BlockedBy = BlockForPos.BlockedBy, BlockNotes = BlockForPos.BlockNotes
	FROM Positions WITH(NOLOCK)
	JOIN Companies WITH(NOLOCK)
		ON Companies.CompaniesID = Positions.CompaniesID
	OUTER APPLY(
		SELECT TOP 1 EnhancedCompanyBlock FROM ClientConfig WITH(NOLOCK)
	) CC(ENH)
	OUTER APPLY(
		SELECT TOP 1 CB.Block, CB.BlockUntilDate, CB.BlockedBy, CB.BlockNotes
		FROM CompaniesBlock CB WITH(NOLOCK)
		OUTER APPLY(
			SELECT COUNT(1), COUNT(Pos.IsAddressBlocked)
			FROM CompaniesBlockByAddresses CBA WITH(NOLOCK)
			OUTER APPLY(
				SELECT CASE WHEN CBA.AddressesID = Positions.AddressesID THEN 1 ELSE NULL END
			) Pos(IsAddressBlocked)
			WHERE CBA.CompaniesID = CB.CompaniesID
			AND ISNULL(ProjectsID, 0) = ISNULL(CB.ProjectsID, 0)
		) AddressBlocks(NumForComp, NumAtPos)
		OUTER APPLY(
			SELECT COUNT(1), COUNT(Pos.IsRoleBlocked)
			FROM CompaniesBlockByRoleCodes CBR WITH(NOLOCK)
			OUTER APPLY(
				SELECT CASE WHEN ISNULL(CBR.RoleCode1, 0) = ISNULL(Positions.RoleCode1, 0) AND ISNULL(CBR.RoleCode2, 0) = ISNULL(Positions.RoleCode2, 0) THEN 1 ELSE NULL END
			) Pos(IsRoleBlocked)
			WHERE CBR.CompaniesID = CB.CompaniesID
			AND ISNULL(CBR.ProjectsID, 0) = ISNULL(CB.ProjectsID, 0)
		) RoleBlocks(NumForComp, NumAtPos)
		OUTER APPLY(
			SELECT COUNT(1), COUNT(Pos.IsSkillBlocked)
			FROM CompaniesBlockBySkills CBS WITH(NOLOCK)
			OUTER APPLY(
				SELECT CASE WHEN EXISTS(
					SELECT 1
					FROM LinkPeopleToSkills L WITH(NOLOCK)
					WHERE L.PositionsID = @PositionsID
					AND L.SkillsID = CBS.SkillsID
					AND ISNULL(L.SkillCategoryID, 0) = ISNULL(CBS.SkillCategoryID, 0)
				) THEN 1 ELSE NULL END
			) Pos(IsSkillBlocked)
			WHERE CBS.CompaniesID = CB.CompaniesID
			AND ISNULL(CBS.ProjectsID, 0) = ISNULL(CB.ProjectsID, 0)
		) SkillBlocks(NumForComp, NumAtPos)
		WHERE CB.CompaniesID = Positions.CompaniesID
		AND CB.Block > 0
		AND (AddressBlocks.NumForComp = 0 OR AddressBlocks.NumAtPos > 0)
		AND (RoleBlocks.NumForComp = 0 OR RoleBlocks.NumAtPos > 0)
		AND (SkillBlocks.NumForComp = 0 OR SkillBlocks.NumAtPos > 0)
		ORDER BY CASE WHEN CB.BlockUntilDate IS NULL THEN 0 ELSE 1 END, CB.BlockUntilDate DESC, CB.CompaniesBlockID
	) EnhBlockForPos
	OUTER APPLY(
		SELECT CASE WHEN CC.ENH = 1 THEN EnhBlockForPos.Block ELSE Companies.Block END,
		CASE WHEN CC.ENH = 1 THEN EnhBlockForPos.BlockUntilDate ELSE Companies.BlockUntilDate END,
		CASE WHEN CC.ENH = 1 THEN EnhBlockForPos.BlockedBy ELSE Companies.BlockedBy END,
		CASE WHEN CC.ENH = 1 THEN EnhBlockForPos.BlockNotes ELSE Companies.BlockNotes END
	) BlockForPos(Block, BlockUntilDate, BlockedBy, BlockNotes)
	WHERE Positions.PositionsID = @PositionsID
	AND (Positions.EndDate IS NULL OR Positions.EndDate > GETDATE())
	AND (BlockForPos.BlockUntilDate IS NULL OR BlockForPos.BlockUntilDate > GETDATE())
	AND BlockForPos.Block > 0
GO
GRANT SELECT ON COMPBLOCKINFO TO DeskflowUsers
GO

CREATE FUNCTION dbo.BLOKINFO(@PeopleID int, @USE_ENH_BLOCK int )  
RETURNS TABLE AS
RETURN
	SELECT TOP 1 CB1.Block, CB1.BDate, NCName = C1.Company, ClientEmployee = 1   
	FROM Positions P1 WITH(NOLOCK) LEFT JOIN Companies C1 ON (P1.CompaniesID = C1.CompaniesID)    
	OUTER APPLY dbo.COMPBLOCKINFO( P1.PositionsID ) AS CB1  
	WHERE ( CB1.Block > 0 and P1.PeopleID = @PeopleID and IsNull(P1.Enddate,getdate() + 1) > getdate() )    
	ORDER BY CASE WHEN CB1.BDate IS NULL THEN 0 ELSE 1 END, CB1.BDate DESC, NCName, C1.CompaniesID 
GO
GRANT SELECT ON BLOKINFO TO DeskflowUsers
GO