--define table type for input to sp_Sovren_MapToDFSkills
if not exists(select * from sys.types where name = 'SovSkillMap_Input') begin
	create type SovSkillMap_Input as table(id int identity primary key, SkillName nvarchar(255), SubCategoryName nvarchar(80), ParentCategoryName nvarchar(80))
end
go

grant execute, references on type::dbo.SovSkillMap_Input to DeskflowUsers
go


/*
	sp_Sovren_MapToDFSkills
	Drew, updated Nov 5 2020
	input:
		table of skills returned from parsed resume. Sovren taxonomy.
		If there is no sub category, leave SubCategoryName as null or blank
	action:
		Map each skill to the corresponding Deskflow skill.
		Possible cases:
			Skill exists in one non-Sovren category: map to that category
			Skill exists in multiple non-Sovren categories: return null category
			Skill exists in Sovren category: map to that category
			Skill uncategorized: leave category null
			Skill does not exist in Deskflow:
				CreateSovrenSkills enabled: add skill under 'Sovren Skills', map to that
				CreateSovrenSkills disabled: do not include skill in output
	output: 
		id to match input table, plus mapped SkillsID and SkillsCategoriesID.
		only returns skills that were successfully mapped to Deskflow
*/

if object_id('sp_Sovren_MapToDFSkills') is not null
	drop proc sp_Sovren_MapToDFSkills
go

create proc sp_Sovren_MapToDFSkills(@SovSkills SovSkillMap_Input readonly)
as

--Admin setting
declare @CreateSovSkills bit = (select top 1 CreateSovrenSkills from ClientConfig)

--'Sovren Skills' category
declare @SovSkillsCatID int = (select top 1 SkillsCategories.SkillsCategoriesID from SkillsCategories where Name = 'Sovren Skills')

--create if doesn't exist
if @CreateSovSkills = 1 and @SovSkillsCatID is null begin
	exec GetNewID 'SkillsCategoriesID', @SovSkillsCatID output
	
	insert SkillsCategories(SkillsCategoriesID, ParentID, SourceTable, Name)
	values(@SovSkillsCatID, 0, 0, 'Sovren Skills')
end
	
--output table
declare @SkillMap table(SovSkillsID int primary key, SkillName nvarchar(255), SkillsID int, SkillsCategoriesID int, Mapped bit default(0))

--existing skills > output
insert into @SkillMap(SovSkillsID, SkillName, SkillsID)
select SovSkills.id, SovSkills.SkillName, DFSkill.SkillsID
from @SovSkills SovSkills
cross apply(
	select top 1 SkillsID
	from Skills
	where Name = SovSkills.SkillName
) DFSkill
where SovSkills.SkillName > ''

--all existing categories for existing skills
declare @AllExistingCats table (id int identity primary key, SkillsID int, CatID int, TLCatID int)
insert @AllExistingCats(SkillsID, CatID, TLCatID)
select sm.SkillsID, tlsc.SkillsCategoriesID, tlsc.TLSkillsCategoriesID
from @SkillMap sm
join TopLevelSkillCategories tlsc
	on tlsc.SkillsID = sm.SkillsID

--multiple existing Deskflow cats - leave Category null
update SkillMap
set Mapped = 1
from @SkillMap SkillMap
where SkillsID in(
	select SkillsID
	from @AllExistingCats
	where TLCatID <> @SovSkillsCatID
	group by SkillsID having count(1) > 1
)

--single existing Deskflow cat - map
update SkillMap
set Mapped = 1, SkillsCategoriesID = singleCat.CatID
from @SkillMap SkillMap
join (
	select SkillsID, CatID, NumCats = count(1) over(partition by SkillsID)
	from @AllExistingCats
	where TLCatID <> @SovSkillsCatID
) SingleCat
	on SingleCat.SkillsID = SkillMap.SkillsID
	and SingleCat.NumCats = 1

--existing Sovren category - map
update SkillMap
set Mapped = 1, SkillsCategoriesID = sovCat.CatID
from @SkillMap SkillMap
cross apply(
	select top 1 CatID
	from @AllExistingCats AllCats
	where AllCats.SkillsID = SkillMap.SkillsID
	and AllCats.TLCatID = @SovSkillsCatID
) sovCat
where SkillMap.Mapped = 0

--uncategorized - mark mapped
update @SkillMap
set Mapped = 1
where SkillsID is not null

--new skills - create
if @CreateSovSkills = 1 begin
	--identify new skills
	declare @NewSovSkills table(id int identity primary key, SovSkillsID int unique not null, SkillName nvarchar(255), SubCategoryName nvarchar(80), ParentCategoryName nvarchar(80), SkillsID int, SubCategoryID int, ParentCategoryID int)
	insert @NewSovSkills(SovSkillsID, SkillName, SubCategoryName, ParentCategoryName)
	select SovSkills.id, SovSkills.SkillName, SovSkills.SubCategoryName, SovSkills.ParentCategoryName
	from @SovSkills SovSkills
	where SovSkills.id not in(
		select SovSkillsID
		from @SkillMap
	)
	and SovSkills.SkillName > ''

	--map existing parent cats
	update nss
	set ParentCategoryID = pc.SkillsCategoriesID
	from @NewSovSkills nss
	join SkillsCategories pc
		on pc.Name = nss.ParentCategoryName
		and pc.ParentID = @SovSkillsCatID

	--table of new parent categories
	declare @NewParentCats table(id int identity primary key, SkillsCategoriesID int, Name nvarchar(80))

	insert into @NewParentCats(Name)
	select distinct ParentCategoryName
	from @NewSovSkills
	where ParentCategoryID is null and ParentCategoryName > ''

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
	
		--map id to new skills
		update nss
		set ParentCategoryID = npc.SkillsCategoriesID
		from @NewSovSkills nss
		join @NewParentCats npc
			on npc.Name = nss.ParentCategoryName
	end

	--map existing sub cat ids
	update nss
	set SubCategoryID = sc.SkillsCategoriesID
	from @NewSovSkills nss
	join SkillsCategories sc
		on sc.ParentID = nss.ParentCategoryID
		and sc.Name = nss.SubCategoryName
	
	--table of new sub cats
	declare @NewSubCats table(id int identity primary key, SkillsCategoriesID int, ParentCatID int, Name nvarchar(80))

	insert into @NewSubCats(ParentCatID, Name)
	select distinct ParentCategoryID, SubCategoryName
	from @NewSovSkills
	where SubCategoryID is null and SubCategoryName > ''

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
		update nss
		set SubCategoryID = nsc.SkillsCategoriesID
		from @NewSovSkills nss
		join @NewSubCats nsc
			on nsc.Name = nss.SubCategoryName
			and nsc.ParentCatID = nss.ParentCategoryID
	end

	--table of new skills
	declare @NewSkills table(id int identity primary key, SkillsID int, Name nvarchar(255))

	insert into @NewSkills(Name)
	select distinct SkillName
	from @NewSovSkills

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
		update nss
		set SkillsID = NewSkills.SkillsID
		from @NewSovSkills nss
		join @NewSkills NewSkills
			on NewSkills.Name = nss.SkillName
	end

	--put subcat skills in subcat
	insert into LinkSkillsToSkillsCategories(LeftID, RightID)
	select distinct nss.SkillsID, nss.ParentCategoryID
	from @NewSovSkills nss
	left join LinkSkillsToSkillsCategories existing
		on existing.LeftID = nss.SkillsID
		and existing.RightID = nss.ParentCategoryID
	where nss.SubCategoryID is null
	and nss.SkillsID is not null
	and nss.ParentCategoryID is not null
	and existing.LeftID is null

	--put parent cat skills in parent cat
	insert into LinkSkillsToSkillsCategories(LeftID, RightID)
	select distinct nss.SkillsID, nss.SubCategoryID
	from @NewSovSkills nss
	left join LinkSkillsToSkillsCategories existing
		on existing.LeftID = nss.SkillsID
		and existing.RightID = nss.SubCategoryID
	where existing.LeftID is null
	and nss.SkillsID is not null
	and nss.SubCategoryID is not null

	--new skills to output table
	insert @SkillMap(SovSkillsID, SkillName, SkillsID, SkillsCategoriesID)
	select SovSkillsID, SkillName, SkillsID, isnull(SubCategoryID, ParentCategoryID)
	from @NewSovSkills
end

--output
select sm.SovSkillsID, sm.SkillName, ss.SubCategoryName, ss.ParentCategoryName, sm.SkillsID, sm.SkillsCategoriesID
from @SkillMap sm
join @SovSkills ss
	on ss.id = sm.SovSkillsID

go

grant execute on sp_Sovren_MapToDFSkills to DeskflowUsers
go


