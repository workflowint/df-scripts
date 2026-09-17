/****
	Keeps Drew's custom GetNewIDs (plural) sproc compatible with Nick Kooj's new GetNewID (singular) sproc
	Run after Nick's script '2-Execute upgrade' which calls usp_id_upgrade
*/

BEGIN TRY DROP PROCEDURE GetNewIDs END TRY BEGIN CATCH END CATCH
GO

CREATE PROCEDURE GetNewIDs (@FieldName varchar(255))
AS
	DECLARE @crlf nvarchar(max) = CHAR(13) + CHAR(10);
	DECLARE @IDTableName nvarchar(255) = QUOTENAME('ID_' + @FieldName)

	DECLARE @SQL nvarchar(max) =
		--output table
		'declare @NewIDs table(RowID int, RecordID int)' + @crlf + @crlf
		
		--insert delete as atom
		+ 'begin tran' + @crlf

		--puts N rows in id table
		--copies them to output table
		--(uses merge as hack to use 'default values' for multiple rows in one insert)
		+ '	merge '+@IDTableName+' as target' + @crlf
		+ '	using #GetNewIDs as source' + @crlf
		+ '		on 1 = 2' + @crlf
		+ '	when not matched and source.RecordID is null then' + @crlf
		+ '		insert default values' + @crlf
		+ '	output source.rowid, inserted.id into @NewIDs(RowID, RecordID)' + @crlf
		+ '	;' + @crlf + @crlf
		
		--delete created rows
		+ '	delete idtable' + @crlf
		+ '	from '+@IDTableName+' idtable' + @crlf
		+ '	join @NewIDs NewIDs' + @crlf
		+ '		on NewIDs.RecordID = idtable.ID' + @crlf

		--return values
		+ '	update #GetNewIDs' + @crlf
		+ '	set RecordID = NewIDs.RecordID' + @crlf
		+ '	from #GetNewIDs' + @crlf
		+ '	join @NewIDs NewIDs' + @crlf
		+ '		on NewIDs.RowID = #GetNewIDs.RowID' + @crlf + @crlf

		--end atom
		+ 'commit tran' + @crlf

	--run SQL (SELECTs for output)
	exec sp_executesql @SQL

GO

GRANT EXECUTE ON GetNewIDs to DeskflowUsers
GO

--===== Example Usage:
/*
--Preliminary data
	--Importing a table of companies.
	DECLARE @CompaniesImport table(RowID int identity, CompaniesID int, Company varchar(255))
	INSERT @CompaniesImport(CompaniesID, Company) VALUES
		(NULL, 'Testflow International'),	--new company, needs an ID
		(26325, 'ADP Services Inc.'),		--matched to existing record, doesn't need an ID
		(NULL, 'Worktest International')	--another new company

	SELECT * FROM @CompaniesImport

--New IDs
	--Prep GetNewIDs table
	if OBJECT_ID('tempdb..#GetNewIDs') IS NOT NULL
		DROP TABLE #GetNewIDs
	CREATE TABLE #GetNewIDs(RowID int unique not null, RecordID int)
	
	INSERT INTO #GetNewIDs(RowID, RecordID)
	SELECT RowID, CompaniesID FROM @CompaniesImport

	--Get New IDs
	EXEC GetNewIDs 'CompaniesID'
	
	--Link new IDs back to import table
	UPDATE Imp
	SET CompaniesID = #GetNewIDs.RecordID
	FROM @CompaniesImport Imp
	JOIN #GetNewIDs
		ON #GetNewIDs.RowID = Imp.RowID

--Results
	SELECT * FROM @CompaniesImport
*/