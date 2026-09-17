GO

/****** Object:  StoredProcedure [dbo].[GetNewID_New]    Script Date: 11/13/2018 8:09:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 13 Nov 2018
-- Description:	New GetNewID Stored Procedure
-- =============================================
CREATE     PROCEDURE [dbo].[GetNewID_New] @Name varchar(30), @LastID int OUTPUT
AS

-- don't return row counts
set nocount on

-- quote table name to avoid injection
declare @table nvarchar(258) = quotename('ID_' + @name);

-- local transaction for insert-delete atomicity
begin tran;

-- execute dynamic insert-delete into ID table
exec(N'insert ' + @table + N' default values;delete ' + @table + N' where ID=@@identity');

-- error check
if @@error = 0
    -- new PK
    set @lastid = @@identity;

commit tran;
GO

-- Grant permissions
grant execute on [dbo].[GetNewId_New] to [DeskFlowUsers];


GO

/****** Object:  StoredProcedure [dbo].[usp_Reset_LastIds]    Script Date: 11/13/2018 8:09:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 13 Nov 2018
-- Description:	Update LastId values to the Maximum value in the corresponding table.
-- =============================================
CREATE PROCEDURE [dbo].[usp_Reset_LastIds]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- new line
	declare @crlf nvarchar(max) = CHAR(13) + CHAR(10);

	-- open cursor for table metadata
	declare c cursor local for select FieldName, LastId from Lastids;
	open c;

	while 1 = 1 begin
		declare @fieldName varchar(max);
		declare @lastId int;
		FETCH NEXT FROM c into @fieldName, @lastId;
		if @@FETCH_STATUS <> 0 break;

		-- strip trailing two 'ID' characters to obtain tablename
		declare @tableName nvarchar(max) = left(@fieldName,len(@FieldName)-2);

		-- output SQL
		declare @sql nvarchar(max) = '';

		print @fieldName;

		-- drop ID table if it exists
		select @sql = @sql +	
			'begin' + @crlf +
			'declare @id int = (select coalesce(max(' + @fieldName + '),1) from [dbo].[' + @tableName + ']);' + @crlf +
			'print @id;' + @crlf +
			'update LastIds set Lastid = (@id) where fieldName = ''' + @fieldName + ''';' + @crlf +
			'end' + @crlf;

		-- trace SQL
		--print @sql;

		-- run SQL
		exec (@sql)

	end

END
GO

GO

/****** Object:  StoredProcedure [dbo].[usp_Id_Upgrade]    Script Date: 11/13/2018 8:09:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 12 Nov 2018
-- Description:	LastIds to ID_* Create Script Generator
-- =============================================
CREATE PROCEDURE [dbo].[usp_Id_Upgrade]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- first we reset all LastId values
	exec usp_Reset_LastIds;

	-- new line
	declare @crlf nvarchar(max) = CHAR(13) + CHAR(10);

	-- open cursor for table metadata
	declare c cursor local for select FieldName, LastId from Lastids;
	open c;

	WHILE 0 = 0 begin
		declare @fieldName varchar(max);
		declare @lastId int;
		FETCH NEXT FROM c into @fieldName, @lastId;
		if @@FETCH_STATUS <> 0 break;

		-- output SQL
		declare @sql nvarchar(max) = '';

		-- drop ID table if it exists
		select @sql = @sql +
			'if OBJECT_ID(''[dbo].[ID_' + @fieldName + ']'',''U'') is not null DROP TABLE [dbo].[ID_' + @fieldName + '];' + @crlf;

		-- create ID_ table
		select @sql = @sql +
			'CREATE TABLE [dbo].[ID_' + @fieldName + '](' + @crlf +
			'  [ID] [int] IDENTITY(1,1) NOT NULL,' + @crlf +
			'  CONSTRAINT [PK_ID_' + @fieldName + '] PRIMARY KEY CLUSTERED ' + @crlf +
			'  ([ID] ASC) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]' + @crlf +
			') ON [PRIMARY];' + @crlf;

		-- adjust permissions
		select @sql = @sql +
			'GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[ID_' + @fieldName + '] TO [DeskFlowUsers];' + @crlf;

		-- seed identity for table
		select @sql = @sql +
			'DBCC CHECKIDENT ([ID_' + @fieldName + '],reseed,' + cast((@lastId + 1) as varchar(max)) + ');' + @crlf;

		declare @id int;

		-- trace SQL
		print @sql;

		-- run SQL
		exec (@sql)

	end

	-- Check for the existance of the legacy GetNewID stored procedure
	if OBJECT_ID('[dbo].[GetNewID_New]') is null begin
		-- Legacy Stored procedure not found; assume not upgraded
		print 'Stored procedure GetNewID_New not found.'
	end else begin
		if OBJECT_ID('[dbo].[GetNewID]') is not null begin
			-- move legacy GetNewID out of the way
			print 'Rename GetNewID -> GetNewID_Legacy'
			exec sp_rename 'GetNewID', 'GetNewID_Legacy';
		end
		-- move new GetNewID
		print 'Rename GetNewID_New -> GetNewID';
		exec sp_rename 'GetNewID_New', 'GetNewID';
	end

END
GO

GO

/****** Object:  StoredProcedure [dbo].[usp_Id_Downgrade]    Script Date: 11/13/2018 8:09:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 12 Nov 2018
-- Description:	Revert to LastIds Generation
-- =============================================
CREATE PROCEDURE [dbo].[usp_Id_Downgrade]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- new line
	declare @crlf nvarchar(max) = CHAR(13) + CHAR(10);

	-- Check for the existance of the legacy GetNewID stored procedure
	if OBJECT_ID('[dbo].[GetNewID_Legacy]') is null begin
		-- Legacy Stored procedure not found; assume not upgraded
		print 'Stored procedure GetNewID_Legacy not found.'
	end else begin
		if OBJECT_ID('[dbo].[GetNewID]') is not null begin
			-- move new GetNewID out of the way
			print 'Rename GetNewID -> GetNewID_New'
			exec sp_rename 'GetNewID', 'GetNewID_New';
		end
		-- restore legacy GetNewID
		print 'Rename GetNewID_Legacy -> GetNewID';
		exec sp_rename 'GetNewID_Legacy', 'GetNewID';
	end

	-- last we reset all LastId values
	exec usp_Reset_LastIds;

	-- open cursor for table metadata
	declare c cursor local for select FieldName, LastId from Lastids;
	open c;

	while 1 = 1 begin
		declare @fieldName varchar(max);
		declare @lastId int;
		FETCH NEXT FROM c into @fieldName, @lastId;
		if @@FETCH_STATUS <> 0 break;

		-- output SQL
		declare @sql nvarchar(max) = '';

		-- drop ID table if it exists
		select @sql = @sql +	
			'if OBJECT_ID(''[dbo].[ID_' + @fieldName + ']'',''U'') is not null DROP TABLE [dbo].[ID_' + @fieldName + '];' + @crlf;

		-- trace SQL
		print @sql;

		-- run SQL
		exec (@sql)

	end

END
GO




/****** Object:  StoredProcedure [dbo].[usp_Id_Reseed]    Script Date: 11/13/2018 8:27:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 13 Nov 2018
-- Description:	Update ID_* table ID column seed values to the max(pk) + 1 in the corresponding table.
-- =============================================
create PROCEDURE [dbo].[usp_Id_Reseed]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- new line
	declare @crlf nvarchar(max) = CHAR(13) + CHAR(10);

	-- open cursor for table metadata
	declare c cursor local for select FieldName, LastId from Lastids;
	open c;

	while 1 = 1 begin
		declare @fieldName varchar(max);
		declare @lastId int;
		FETCH NEXT FROM c into @fieldName, @lastId;
		if @@FETCH_STATUS <> 0 break;

		-- strip trailing two 'ID' characters to obtain tablename
		declare @tableName nvarchar(max) = left(@fieldName,len(@FieldName)-2);

		-- output SQL
		declare @sql nvarchar(max) = '';

		print @fieldName;

		-- drop ID table if it exists
		select @sql = @sql +	
			'begin' + @crlf +
			'declare @id int = (select coalesce(max(' + @fieldName + ') + 1,1) from [dbo].[' + @tableName + ']);' + @crlf +
			'print @id;' + @crlf +
			-- Reseed ID column
			'DBCC CHECKIDENT ([ID_' + @fieldName + '],reseed,@id);' + @crlf +
			'end' + @crlf;

		-- trace SQL
		--print @sql;

		-- run SQL
		exec (@sql)

	end

END
GO

