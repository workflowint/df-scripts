CREATE FUNCTION [dbo].[PeopleSkillsTree](@PeopleID int )
RETURNS @PeopleSkillsTable TABLE (
   SkillsCategoriesID  int   , ParentID int, RightID int, LinkPeopleToSkillsID int, 
	LeftID int, SkillsID int, TreeParentID int,CategoryName varchar (255), 
	 SkillName varchar(255), Measurement varchar(255), 
	 IntValue int, LastUsed int, SkillLevelName varchar(255), 
	 JobTitle varchar(255), CompanyName  varchar(255), PositionsID int
) 
AS
BEGIN
declare @ParentCatID int 
declare @CatID int 
declare @ListOfIDs varchar(8000) 
SET @ParentCatID = 0 
SET @ListOfIDs = '' 

DECLARE @DataTable table
(	CategoryID int
)
DECLARE SCat_Cursor CURSOR LOCAL FOR 
SELECT DISTINCT LinkSkillsToSkillsCategories.RightID 
FROM LinkSkillsToSkillsCategories WITH(NOLOCK) 
 JOIN LinkPeopleToSkills WITH(NOLOCK) ON ( LinkPeopleToSkills.PeopleID = @PeopleID AND 
 ISNULL( LinkPeopleToSkills.SkillCategoryID, LinkPeopleToSkills.SkillsID) = 
 CASE 
 WHEN (LinkPeopleToSkills.SkillCategoryID) > 0 THEN LinkSkillsToSkillsCategories.RightID 
 ELSE LinkSkillsToSkillsCategories.LeftID 
 END 
   ) 
  ORDER BY LinkSkillsToSkillsCategories.RightID DESC 
  OPEN SCat_Cursor 
  FETCH NEXT FROM SCat_Cursor into @CatID 
  WHILE @@FETCH_STATUS = 0  
  BEGIN 
     INSERT INTO @DataTable (CategoryID ) VALUES ( @CatID )
     SELECT @ParentCatID = ParentID FROM SkillsCategories WITH(NOLOCK)WHERE SkillsCategories.SkillsCategoriesID = @CatID 
     WHILE ( @ParentCatID > 0 AND @ParentCatID <> @CatID) 
      BEGIN 
	     INSERT INTO @DataTable (CategoryID ) VALUES ( @ParentCatID )
       SELECT @ParentCatID = ISNULL(ParentID, 0), @CatID = SkillsCategories.SkillsCategoriesID 
      FROM SkillsCategories WITH(NOLOCK) WHERE SkillsCategories.SkillsCategoriesID = @ParentCatID 
     END 
    FETCH NEXT FROM SCat_Cursor into @CatID 
   END 
CLOSE SCat_Cursor 
DEALLOCATE SCat_Cursor 

 insert into @PeopleSkillsTable  (  SkillsCategoriesID, ParentID, RightID, LinkPeopleToSkillsID, 
	LeftID , SkillsID, TreeParentID,CategoryName, SkillName, Measurement, 
	 IntValue, LastUsed, SkillLevelName, JobTitle, CompanyName, PositionsID)
SELECT SkillsCategories.SkillsCategoriesID, ParentID, 
 LinkSkillsToSkillsCategories.RightID, LinkPeopleToSkillsID, 
 LinkSkillsToSkillsCategories.LeftID, Skills.SkillsID, 
 TreeParentID = 
 	CASE 
 		WHEN Skills.SkillsID > 0 THEN SkillsCategories.SkillsCategoriesID 
 		ELSE ParentID 
 	END, 
 SkillsCategories.Name AS CategoryName, 
 Skills.Name AS SkillName, SkillsMeasurement.Name AS Measurement, 
 IntValue, LastUsed, SkillsLevels.Name AS SkillLevelName, 
 Positions.JobTitle, Positions.CompanyName, LinkPeopleToSkills.PositionsID 
 FROM Skills WITH(NOLOCK) 
 JOIN LinkPeopleToSkills WITH(NOLOCK) 
 ON ( LinkPeopleToSkills.SkillsID = Skills.SkillsID AND LinkPeopleToSkills.PeopleID = @PeopleID ) 
 LEFT JOIN Positions WITH(NOLOCK) ON ( LinkPeopleToSkills.PositionsID = Positions.PositionsID) 
 LEFT JOIN LinkSkillsToSkillsCategories WITH(NOLOCK) 
   ON (  (LinkSkillsToSkillsCategories.LeftID = Skills.SkillsID) 
    AND 
    ISNULL(LinkPeopleToSkills.SkillCategoryID, Skills.SkillsID) = 
    CASE 
        WHEN(LinkPeopleToSkills.SkillCategoryID > 0) THEN LinkSkillsToSkillsCategories.RightID 
        ELSE LinkSkillsToSkillsCategories.LeftID 
    END 
    AND LinkSkillsToSkillsCategories.LeftID  IN( SELECT SkillsID from LinkPeopleToSkills with ( nolock) where PeopleID=@PeopleID) ) 
 LEFT JOIN SkillsCategories WITH(NOLOCK) 
 ON ( SkillsCategories.SkillsCategoriesID = LinkSkillsToSkillsCategories.RightID ) 
 LEFT JOIN SkillsMeasurement ON ( Skills.SkillsMeasurementID = SkillsMeasurement.SkillsMeasurementID) 
 LEFT JOIN SkillsLevels ON ( LinkPeopleToSkills.SkillsLevelsID = SkillsLevels.SkillsLevelsID) 
 UNION 
 SELECT SkillsCategories.SkillsCategoriesID, ParentID, NULL, NULL, NULL, NULL, ParentID AS TreeParentID, 
 SkillsCategories.Name AS CategoryName, 
 NULL AS SkillName, NULL AS Measurement, 
 NULL AS IntValue, NULL AS LastUsed, NULL AS SkillLevelName, NULL AS JobTitle, NULL As CompanyName, 
 NULL AS PositionsID 
 FROM SkillsCategories WITH(NOLOCK)
 WHERE SkillsCategories.SkillsCategoriesID IN ( select CategoryID from @DataTable ) 
 ORDER BY 2, 9, 1
RETURN 
END

GO

GRANT  SELECT ON [dbo].[PeopleSkillsTree]  TO [DeskFlowUsers]

GO
