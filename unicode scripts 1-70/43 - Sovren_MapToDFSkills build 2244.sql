--define table type for input to sp_Sovren_MapToDFSkills
begin try drop type SovSkillMap_Input end try begin catch end catch
go

create type SovSkillMap_Input as table(id int identity primary key, SkillName nvarchar(255), SubCategoryName nvarchar(80), ParentCategoryName nvarchar(80))
go

grant execute, references on type::dbo.SovSkillMap_Input to DeskflowUsers
go

/*
	sp_Sovren_MapToDFSkills
	Drew, Aug 20 2020
	input - table of skills returned from parsed resume. Sovren format.
		If there is no sub category, leave SubCategoryName as null or blank
	action - create any skills, categories, skill-category links that don't exist in Deskflow.
		map Sovren skills to Deskflow skills IDs
	output - same table but including Deskflow Skill/category ids
*/

if object_id('sp_Sovren_MapToDFSkills') is not null
	drop proc sp_Sovren_MapToDFSkills
go

create proc sp_Sovren_MapToDFSkills(@SovSkills SovSkillMap_Input readonly)
as

--'Sovren Skills' category
declare @SovSkillsCatID int = (select top 1 SkillsCategories.SkillsCategoriesID from SkillsCategories where Name = 'Sovren Skills')

--create if doesn't exist
if @SovSkillsCatID is null begin
	exec GetNewID 'SkillsCategoriesID', @SovSkillsCatID output
	
	insert SkillsCategories(SkillsCategoriesID, ParentID, SourceTable, Name)
	values(@SovSkillsCatID, 0, 0, 'Sovren Skills')
end

--populate output table
declare @SkillMap table(id int primary key, SkillName nvarchar(255), SubCategoryName nvarchar(80), ParentCategoryName nvarchar(80), SkillsID int, SubCatID int, ParentCatID int)

insert into @SkillMap(id, SkillName, SubCategoryName, ParentCategoryName)
select id, SkillName, SubCategoryName, ParentCategoryName
from @SovSkills

--map existing parent cat ids
update SkillMap
set ParentCatID = sc.SkillsCategoriesID
from @SkillMap SkillMap
join SkillsCategories sc
	on sc.ParentID = @SovSkillsCatID
	and sc.Name = SkillMap.ParentCategoryName
	
--table of new parent categories
declare @NewParentCats table(id int identity primary key, SkillsCategoriesID int, Name nvarchar(80))

insert into @NewParentCats(Name)
select distinct ParentCategoryName
from @SkillMap
where ParentCatID is null and ParentCategoryName > ''

--if any new:
if @@ROWCOUNT > 0 begin
	--loop to get new ids
	declare @npcid int = (select count(1) from @NewParentCats)
	while @npcid > 0 begin
		--get id
		declare @ParentCatID int
		exec GetNewID 'SkillsCategoriesID', @ParentCatID output
		
		--put in npc table
		update @NewParentCats
		set SkillsCategoriesID = @ParentCatID
		where id = @npcid

		--decrement
		set @npcid = @npcid - 1
	end

	--create cats in Deskflow
	insert SkillsCategories(SkillsCategoriesID, ParentID, SourceTable, Name)
	select SkillsCategoriesID, @SovSkillsCatID, 0, Name
	from @NewParentCats
	
	--map id to skill map
	update sm
	set ParentCatID = npc.SkillsCategoriesID
	from @SkillMap sm
	join @NewParentCats npc
		on npc.Name = sm.ParentCategoryName
end


--map existing sub cat ids
update SkillMap
set SubCatID = sc.SkillsCategoriesID
from @SkillMap SkillMap
join SkillsCategories sc
	on sc.ParentID = SkillMap.ParentCatID
	and sc.Name = SkillMap.SubCategoryName
	
--table of new sub cats
declare @NewSubCats table(id int identity primary key, SkillsCategoriesID int, ParentCatID int, Name nvarchar(80))

insert into @NewSubCats(ParentCatID, Name)
select distinct ParentCatID, SubCategoryName
from @SkillMap
where SubCatID is null and SubCategoryName > ''

--if any new:
if @@ROWCOUNT > 0 begin
	--loop to get new ids
	declare @nscid int = (select count(1) from @NewSubCats)
	while @nscid > 0 begin
		--get id
		declare @SubCatID int
		exec GetNewID 'SkillsCategoriesID', @SubCatID output
		
		--put in npc table
		update @NewSubCats
		set SkillsCategoriesID = @SubCatID
		where id = @nscid

		--decrement
		set @nscid = @nscid - 1
	end

	--create cats in Deskflow
	insert SkillsCategories(SkillsCategoriesID, ParentID, SourceTable, Name)
	select SkillsCategoriesID, ParentCatID, 0, Name
	from @NewSubCats
	
	--map id to skill map
	update sm
	set SubCatID = nsc.SkillsCategoriesID
	from @SkillMap sm
	join @NewSubCats nsc
		on nsc.Name = sm.SubCategoryName
		and nsc.ParentCatID = sm.ParentCatID
end


--map existing skills
update SkillMap
set SkillsID = Skills.SkillsID
from @SkillMap SkillMap
join Skills
	on Skills.Name = SkillMap.SkillName

--table of new skills
declare @NewSkills table(id int identity primary key, SkillsID int, Name nvarchar(255))

insert into @NewSkills(Name)
select distinct SkillName
from @SkillMap
where SkillsID is null
and SkillName > ''

--if any new
if @@ROWCOUNT > 0 begin
	--loop to get new ids
	declare @nsid int = (select count(1) from @NewSkills)
	while @nsid > 0 begin
		--make skill id
		declare @SkillsID int
		exec GetNewID 'SkillsID', @SkillsID output

		--put in new skill table
		update @NewSkills
		set SkillsID = @SkillsID
		where id = @nsid

		--decrement
		set @nsid = @nsid - 1
	end

	--create in Deskflow
	insert into Skills(SkillsID, SourceTable, Name)
	select SkillsID, 0, Name
	from @NewSkills

	--map id to skill map
	update SkillMap
	set SkillsID = NewSkills.SkillsID
	from @SkillMap SkillMap
	join @NewSkills NewSkills
		on NewSkills.Name = SkillMap.SkillName
end


--make new skill-category links (no sub-category)
insert into LinkSkillsToSkillsCategories(LeftID, RightID)
select distinct sm.SkillsID, sm.ParentCatID
from @SkillMap sm
left join LinkSkillsToSkillsCategories existing
	on existing.LeftID = sm.SkillsID
	and existing.RightID = sm.ParentCatID
where sm.SubCatID is null
and sm.SkillsID is not null
and sm.ParentCatID is not null
and existing.LeftID is null

--make new skill-category links (for sub-category)
insert into LinkSkillsToSkillsCategories(LeftID, RightID)
select distinct sm.SkillsID, sm.SubCatID
from @SkillMap sm
left join LinkSkillsToSkillsCategories existing
	on existing.LeftID = sm.SkillsID
	and existing.RightID = sm.SubCatID
where existing.LeftID is null
and sm.SkillsID is not null
and sm.SubCatID is not null

--output
select * from @SkillMap

go

grant execute on sp_Sovren_MapToDFSkills to DeskflowUsers
go


