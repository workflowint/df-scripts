SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

   
ALTER FUNCTION  [dbo].[fn_GetCompanyBlockForPosition] ( @CompaniesID int, @PositionsID int, @ProjectsID int )      
RETURNS int      
AS      
BEGIN      
      
 DECLARE @ENH_BLOCK int      
 DECLARE @CBLOCK int      
 DECLARE @Ret int      
 SELECT TOP 1 @ENH_BLOCK = EnhancedCompanyBlock FROM ClientConfig WITH(NOLOCK)      
 SELECT @CBLOCK = CompaniesBlock.Block FROM CompaniesBlock WITH(NOLOCK) WHERE CompaniesID = @CompaniesID AND IsNull(@ProjectsID,0) = IsNull(CompaniesBlock.ProjectsID,0)     
 set @CBLOCK = IsNull(@CBLOCK,0)    
 set @Ret = 0      
      
 IF (@ENH_BLOCK < 1 OR @CBLOCK < 2)      
 BEGIN      
  SET @Ret = @CBLOCK      
 END      
 ELSE      
 BEGIN      
       
  -- Check addresses      
  IF EXISTS (      
   SELECT CompaniesBlockByAddresses.CompaniesID       
   FROM CompaniesBlockByAddresses WITH(NOLOCK)      
   WHERE CompaniesBlockByAddresses.CompaniesID = @CompaniesID AND IsNull(ProjectsID,0) = IsNull(@ProjectsID,0)    
  )      
  BEGIN      
         
   SELECT @Ret = Count(*)      
   FROM CompaniesBlockByAddresses WITH(NOLOCK)      
    LEFT JOIN Positions WITH(NOLOCK) ON ( Positions.CompaniesID = CompaniesBlockByAddresses.CompaniesID      
               AND Positions.AddressesID = CompaniesBlockByAddresses.AddressesID )      
   WHERE CompaniesBlockByAddresses.CompaniesID = @CompaniesID AND Positions.PositionsID = @PositionsID      
   AND IsNull(CompaniesBlockByAddresses.ProjectsID,0) = IsNull(@ProjectsID,0)    
         
   IF (@Ret = 0) BEGIN RETURN @Ret END      
      
  END      
      
  -- Check role codes      
  IF EXISTS (      
   SELECT CompaniesBlockByRoleCodes.CompaniesID       
   FROM CompaniesBlockByRoleCodes WITH(NOLOCK)      
   WHERE CompaniesBlockByRoleCodes.CompaniesID = @CompaniesID AND IsNull(ProjectsID,0) = IsNull(@ProjectsID,0)     
  )      
  BEGIN      
   SELECT @Ret = Count(*)      
   FROM CompaniesBlockByRoleCodes WITH(NOLOCK)      
    LEFT JOIN Positions WITH(NOLOCK) ON ( Positions.CompaniesID = CompaniesBlockByRoleCodes.CompaniesID      
               AND IsNull(Positions.RoleCode1,0) = IsNull(CompaniesBlockByRoleCodes.RoleCode1,0)      
               AND IsNull(Positions.RoleCode2,0) = IsNull(CompaniesBlockByRoleCodes.RoleCode2,0) )      
   WHERE CompaniesBlockByRoleCodes.CompaniesID = @CompaniesID AND Positions.PositionsID = @PositionsID      
   AND IsNull(CompaniesBlockByRoleCodes.ProjectsID,0) = IsNull(@ProjectsID,0)    
      
   IF (@Ret = 0) BEGIN RETURN @Ret END      
  END      
        
  -- Check skills      
  IF EXISTS (      
   SELECT CompaniesBlockBySkills.CompaniesID       
   FROM CompaniesBlockBySkills WITH(NOLOCK)      
   WHERE CompaniesBlockBySkills.CompaniesID = @CompaniesID AND IsNull(ProjectsID,0) = IsNull(@ProjectsID,0)        
  )      
  BEGIN      
   SELECT @Ret = Count(*)      
   FROM CompaniesBlockBySkills WITH(NOLOCK)        
    LEFT JOIN Positions WITH(NOLOCK) ON ( Positions.CompaniesID = CompaniesBlockBySkills.CompaniesID )      
    JOIN LinkPeopleToSkills WITH(NOLOCK) ON ( LinkPeopleToSkills.PositionsID = Positions.PositionsID       
                 AND LinkPeopleToSkills.SkillsID = CompaniesBlockBySkills.SkillsID      
                 AND IsNull(LinkPeopleToSkills.SkillCategoryID,0) = IsNull(CompaniesBlockBySkills.SkillCategoryID,0) )      
   WHERE CompaniesBlockBySkills.CompaniesID = @CompaniesID AND Positions.PositionsID = @PositionsID         
      AND IsNull(CompaniesBlockBySkills.ProjectsID,0) = IsNull(@ProjectsID,0)    
      
   IF (@Ret = 0) BEGIN RETURN @Ret END      
      
  END      
       
  IF (@Ret > 0)      
  BEGIN      
   SET @Ret = 1      
  END      
        
 END      
      
 RETURN @Ret      
      
END      
    