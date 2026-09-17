/****** Object:  UserDefinedFunction [dbo].[fn_GetCompanyBlockForPosition] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION  [dbo].[fn_GetCompanyBlockForPosition] ( @CompaniesID int, @PositionsID int )
RETURNS int
AS
BEGIN

	DECLARE @ENH_BLOCK int
	DECLARE @CBLOCK int
	DECLARE @Ret int
	SELECT TOP 1 @ENH_BLOCK = EnhancedCompanyBlock FROM ClientConfig WITH(NOLOCK)
	SELECT @CBLOCK = Companies.Block FROM Companies WITH(NOLOCK) WHERE CompaniesID = @CompaniesID
	set @Ret = 0

	IF (@ENH_BLOCK > 1 OR @CBLOCK < 2)
	BEGIN
		SET @Ret = @CBLOCK
	END
	ELSE
	BEGIN
	
		-- Check addresses
		IF EXISTS (
			SELECT CompaniesBlockByAddresses.CompaniesID 
			FROM CompaniesBlockByAddresses WITH(NOLOCK)
			WHERE CompaniesBlockByAddresses.CompaniesID = @CompaniesID
		)
		BEGIN
			
			SELECT @Ret = Count(*)
			FROM CompaniesBlockByAddresses WITH(NOLOCK)
				LEFT JOIN Positions WITH(NOLOCK) ON ( Positions.CompaniesID = CompaniesBlockByAddresses.CompaniesID
															AND Positions.AddressesID = CompaniesBlockByAddresses.AddressesID )
			WHERE CompaniesBlockByAddresses.CompaniesID = @CompaniesID AND Positions.PositionsID = @PositionsID
			
			IF (@Ret = 0) BEGIN	RETURN @Ret END

		END

		-- Check role codes
		IF EXISTS (
			SELECT CompaniesBlockByRoleCodes.CompaniesID 
			FROM CompaniesBlockByRoleCodes WITH(NOLOCK)
			WHERE CompaniesBlockByRoleCodes.CompaniesID = @CompaniesID
		)
		BEGIN
			SELECT @Ret = Count(*)
			FROM CompaniesBlockByRoleCodes WITH(NOLOCK)
				LEFT JOIN Positions WITH(NOLOCK) ON ( Positions.CompaniesID = CompaniesBlockByRoleCodes.CompaniesID
															AND IsNull(Positions.RoleCode1,0) = IsNull(CompaniesBlockByRoleCodes.RoleCode1,0)
															AND IsNull(Positions.RoleCode2,0) = IsNull(CompaniesBlockByRoleCodes.RoleCode2,0) )
			WHERE CompaniesBlockByRoleCodes.CompaniesID = @CompaniesID AND Positions.PositionsID = @PositionsID

			IF (@Ret = 0) BEGIN	RETURN @Ret END
		END
		
		-- Check skills
		IF EXISTS (
			SELECT CompaniesBlockBySkills.CompaniesID 
			FROM CompaniesBlockBySkills WITH(NOLOCK)
			WHERE CompaniesBlockBySkills.CompaniesID = @CompaniesID			
		)
		BEGIN
			SELECT @Ret = Count(*)
			FROM CompaniesBlockBySkills WITH(NOLOCK)		
				LEFT JOIN Positions WITH(NOLOCK) ON ( Positions.CompaniesID = CompaniesBlockBySkills.CompaniesID )
				JOIN LinkPeopleToSkills WITH(NOLOCK) ON ( LinkPeopleToSkills.PositionsID = Positions.PositionsID 
																	AND LinkPeopleToSkills.SkillsID = CompaniesBlockBySkills.SkillsID
																	AND IsNull(LinkPeopleToSkills.SkillCategoryID,0) = IsNull(CompaniesBlockBySkills.SkillCategoryID,0) )
			WHERE CompaniesBlockBySkills.CompaniesID = @CompaniesID AND Positions.PositionsID = @PositionsID			

			IF (@Ret = 0) BEGIN RETURN @Ret END

		END
	
		IF (@Ret > 0)
		BEGIN
			SET @Ret = 1
		END
		
	END

	RETURN @Ret

END

GO

GRANT EXECUTE ON [dbo].[fn_GetCompanyBlockForPosition]  TO [DeskFlowUsers]

GO

/****** Object:  Table [dbo].[CompaniesBlockByAddresses]    Script Date: 02/19/2015 18:24:38 ******/
CREATE TABLE [dbo].[CompaniesBlockByAddresses](
	[CompaniesID] [int] NOT NULL,
	[AddressesID] [int] NULL
) ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CompaniesBlockByAddresses]  TO [DeskFlowUsers]

GO

/****** Object:  Table [dbo].[CompaniesBlockByRoleCodes]    Script Date: 02/19/2015 18:24:38 ******/
CREATE TABLE [dbo].[CompaniesBlockByRoleCodes](
	[CompaniesID] [int] NOT NULL,
	[RoleCode1] [int] NULL,
	[RoleCode2] [int] NULL
) ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CompaniesBlockByRoleCodes]  TO [DeskFlowUsers]

GO

/****** Object:  Table [dbo].[CompaniesBlockBySkills]    Script Date: 02/19/2015 18:24:38 ******/
CREATE TABLE [dbo].[CompaniesBlockBySkills](
	[CompaniesID] [int] NOT NULL,
	[SkillsID] [int] NULL,
	[SkillCategoryID] [int] NULL
) ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CompaniesBlockBySkills]  TO [DeskFlowUsers]

GO

-- Copy over addresses
INSERT INTO CompaniesBlockByAddresses
SELECT DISTINCT CompaniesBlock.CompaniesID, CompaniesBlock.AddressesID
FROM CompaniesBlock WITH(NOLOCK)
	LEFT JOIN Companies WITH(NOLOCK) ON ( Companies.CompaniesID = CompaniesBlock.CompaniesID )
WHERE CompaniesBlock.AddressesID IS NOT NULL AND Companies.Block > 1

GO

-- Copy over role codes
INSERT INTO CompaniesBlockByRoleCodes
SELECT DISTINCT CompaniesBlock.CompaniesID, CompaniesBlock.RoleCode1, CompaniesBlock.RoleCode2
FROM CompaniesBlock
	LEFT JOIN Companies WITH(NOLOCK) ON ( Companies.CompaniesID = CompaniesBlock.CompaniesID )
WHERE CompaniesBlock.RoleCode1 IS NOT NULL AND Companies.Block > 1

GO

ALTER FUNCTION [dbo].[BLOKINFO](@PeopleID int, @USE_ENH_BLOCK int )
RETURNS @CompanyBlockInfo TABLE (
   Block  int   , BDate datetime, NCname varchar(255), ClientEmployee int
) 
AS
BEGIN

	IF @USE_ENH_BLOCK > 0
		insert into @CompanyBlockInfo ( Block, BDate, NCname, ClientEmployee)
		SELECT TOP 1 C1.Block, C1.BlockUntilDate, C1.Company, ClientEmployee = C1.Block 
		FROM Positions P1 LEFT JOIN Companies C1 ON (P1.CompaniesID = C1.CompaniesID)  
		WHERE ( C1.Block = 1 or (dbo.fn_GetCompanyBlockForPosition(P1.CompaniesID,P1.PositionsID) > 0) ) and P1.PeopleID = @PeopleID and IsNull(P1.Enddate,getdate() + 1) > getdate()  
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