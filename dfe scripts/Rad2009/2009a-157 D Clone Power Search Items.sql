declare @ItemId int
declare @NewItemId int
declare cur CURSOR LOCAL for
	select PeopleSearchID from PeopleSearch

open cur

fetch next from cur into @ItemId

while @@FETCH_STATUS = 0 
BEGIN

	IF NOT EXISTS ( SELECT LegacyID FROM PowerSearchItems WHERE SearchType = 'People' AND LegacyID = @ItemId )
	BEGIN
		-- generate new id for insert
		exec GetNewID @Name='PowerSearchItemsID',@LastID=@NewItemId output;

		--( PowerSearchItemsID,SearchType,FriendlyName,[SQL],FullQuery,TextSearch,FieldName,DataType,LegacyID )
		INSERT INTO PowerSearchItems
		SELECT @NewItemId, 'People', PS.FriendlyName, PS.SQL, PS.FullQuery, PS.TextSearch, PS.FieldName, PS.DataType, @ItemId
		FROM PeopleSearch AS PS WHERE PS.PeopleSearchID = @ItemId
	END



    fetch next from cur into @ItemId
END

close cur
deallocate cur

GO

declare @ItemId int
declare @NewItemId int
declare cur CURSOR LOCAL for
	select CompaniesSearchID from CompaniesSearch

open cur

fetch next from cur into @ItemId

while @@FETCH_STATUS = 0 
BEGIN

	IF NOT EXISTS ( SELECT LegacyID FROM PowerSearchItems WHERE SearchType = 'Company' AND LegacyID = @ItemId )
	BEGIN
		-- generate new id for insert
		exec GetNewID @Name='PowerSearchItemsID',@LastID=@NewItemId output;

		--( PowerSearchItemsID,SearchType,FriendlyName,[SQL],FullQuery,TextSearch,FieldName,DataType,LegacyID )
		INSERT INTO PowerSearchItems
		SELECT @NewItemId, 'Company', PS.FriendlyName, PS.SQL, PS.FullQuery, PS.TextSearch, PS.FieldName, PS.DataType, @ItemId
		FROM CompaniesSearch AS PS WHERE PS.CompaniesSearchID = @ItemId
	END



    fetch next from cur into @ItemId
END

close cur
deallocate cur

GO

declare @ItemId int
declare @NewItemId int
declare cur CURSOR LOCAL for
	select JobOrderSearchID from JobOrderSearch

open cur

fetch next from cur into @ItemId

while @@FETCH_STATUS = 0 
BEGIN

	IF NOT EXISTS ( SELECT LegacyID FROM PowerSearchItems WHERE SearchType = 'JobOrder' AND LegacyID = @ItemId )
	BEGIN
		-- generate new id for insert
		exec GetNewID @Name='PowerSearchItemsID',@LastID=@NewItemId output;

		--( PowerSearchItemsID,SearchType,FriendlyName,[SQL],FullQuery,TextSearch,FieldName,DataType,LegacyID )
		INSERT INTO PowerSearchItems
		SELECT @NewItemId, 'JobOrder', PS.FriendlyName, PS.SQL, PS.FullQuery, PS.TextSearch, PS.FieldName, PS.DataType, @ItemId
		FROM JobOrderSearch AS PS WHERE PS.JobOrderSearchID = @ItemId
	END



    fetch next from cur into @ItemId
END

close cur
deallocate cur

GO

declare @ItemId int
declare @NewItemId int
declare cur CURSOR LOCAL for
	select ProjectsSearchID from ProjectsSearch

open cur

fetch next from cur into @ItemId

while @@FETCH_STATUS = 0 
BEGIN

	IF NOT EXISTS ( SELECT LegacyID FROM PowerSearchItems WHERE SearchType = 'Project' AND LegacyID = @ItemId )
	BEGIN
		-- generate new id for insert
		exec GetNewID @Name='PowerSearchItemsID',@LastID=@NewItemId output;

		--( PowerSearchItemsID,SearchType,FriendlyName,[SQL],FullQuery,TextSearch,FieldName,DataType,LegacyID )
		INSERT INTO PowerSearchItems
		SELECT @NewItemId, 'Project', PS.FriendlyName, PS.SQL, PS.FullQuery, PS.TextSearch, PS.FieldName, PS.DataType, @ItemId
		FROM ProjectsSearch AS PS WHERE PS.ProjectsSearchID = @ItemId
	END



    fetch next from cur into @ItemId
END

close cur
deallocate cur

GO

SELECT * FROM PowerSearchItems