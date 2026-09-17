if object_id('TopLevelSkillCategories') is not null
	drop view TopLevelSkillCategories
go

create view [dbo].[TopLevelSkillCategories] as
with CTE_SkillCats as (
	select s.SkillsID, sc.SkillsCategoriesID, RecursiveCatID = sc.SkillsCategoriesID, RecursiveParentID = sc.ParentID
	from Skills s
	join LinkSkillsToSkillsCategories l
		on l.LeftID = s.SkillsID
	join SkillsCategories sc
		on sc.SkillsCategoriesID = l.RightID
	union all select CTE_SkillCats.SkillsID, CTE_SkillCats.SkillsCategoriesID, RecursiveCatID = sc.SkillsCategoriesID, RecursiveParentID = sc.ParentID
	from CTE_SkillCats
	join SkillsCategories sc
		on sc.SkillsCategoriesID = CTE_SkillCats.RecursiveParentID
	where isnull(CTE_SkillCats.RecursiveCatID, 0) <> isnull(CTE_SkillCats.RecursiveParentID, 0)
)
select SkillsID, SkillsCategoriesID, TLSkillsCategoriesID = RecursiveCatID
from CTE_SkillCats
where RecursiveParentID = 0
or RecursiveParentID = RecursiveCatID

go

grant select on TopLevelSkillCategories to DeskflowUsers
go

select *
from TopLevelSkillCategories
where SkillsID in(16)


select * from LinkSkillsToSkillsCategories where LeftID = 16