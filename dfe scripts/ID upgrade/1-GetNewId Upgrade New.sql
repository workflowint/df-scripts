GO
IF OBJECT_ID ('fn_Ids', 'TF') IS NOT NULL  
   DROP FUNCTION [dbo].[fn_Ids]
GO
IF OBJECT_ID ('fn_Links', 'TF') IS NOT NULL  
   DROP FUNCTION [dbo].[fn_Links]
GO
IF OBJECT_ID ('fn_Strings', 'TF') IS NOT NULL  
   DROP FUNCTION [dbo].[fn_Strings]
GO
IF OBJECT_ID ('fn_Integers', 'TF') IS NOT NULL  
   DROP FUNCTION [dbo].[fn_Integers]
GO
IF OBJECT_ID ('usp_Id_Reseed', 'P') IS NOT NULL  
   DROP PROCEDURE [dbo].[usp_Id_Reseed]
GO
IF OBJECT_ID ('usp_Id_Downgrade', 'P') IS NOT NULL  
   DROP PROCEDURE [dbo].[usp_Id_Downgrade]
GO
IF OBJECT_ID ('usp_Id_Upgrade', 'P') IS NOT NULL  
   DROP PROCEDURE [dbo].[usp_Id_Upgrade]
GO
IF OBJECT_ID ('usp_Reset_LastIds', 'P') IS NOT NULL  
   DROP PROCEDURE [dbo].[usp_Reset_LastIds]
GO
IF OBJECT_ID ('GetNewID_New', 'P') IS NOT NULL  
   DROP PROCEDURE [dbo].[GetNewID_New]
GO
IF OBJECT_ID ('GetNewID_Legacy', 'P') IS NOT NULL  
   DROP PROCEDURE [dbo].[GetNewID_Legacy]
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
	declare c cursor local for select FieldName, LastId from Lastids
		where FieldName not in ('FeePercentID','CompanyHoursID','ProjectsCategoryID','RecurrentID','CompanyGroupsID',
								'WebUserListID','FunctionsID','WarrantyID','LunchTimeID','CompBenefitsID','TempTablesID')
	open c;

	while 1 = 1 begin
		declare @fieldName varchar(max);
		declare @lastId int;
		FETCH NEXT FROM c into @fieldName, @lastId;
		if @@FETCH_STATUS <> 0 break;

		-- strip trailing two 'ID' characters to obtain tablename
		declare @tableName nvarchar(max) = left(@fieldName,len(@FieldName)-2);
		if ( @tableName = 'WorkStepsStatus')
			set @tableName ='WorkStepsStatuses'
		if ( @tableName = 'CompanyIndustries')
			set @tableName ='CompaniesIndustry'
		if ( @tableName = 'LinkToDistList')
			set @tableName ='LinkAddressToDistList'
		if ( @tableName = 'SendSticky')
			set @tableName ='Sticky'
						
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 24 Nov 2018
-- Description:	Table valued function converting a separated string of ids into a set of ids.
--              Can be used to accelerate id insertion.
-- =============================================
create function [dbo].[fn_Ids] (@text varchar(max))   
returns @ids table (  
    id int not null
    --id int primary key not null
)  
AS  
BEGIN

	-- length
	declare @n int = len(@text);

	-- current index
	declare @i int = 1;

	-- until end of text...
	while @i <= @n begin
		-- find next comma
		declare @j int = charindex(',', @text, @i)

		if @j = 0 begin
			-- last id
			set @j = @n + 1;
		end

		declare @id int = substring(@text, @i, @j - @i);

		-- populate ids
		insert into @ids (id) values(@id);

		-- advance
		set @i = @j + 1;
    end
    
    return
END
go

-- Set permissions
grant select on fn_Ids to DeskflowUsers;

GO
-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 28 Nov 2018
-- Description:	Table valued  function converting an  ActivityHistory linkage
--              string to  a set of  {Tablename,Id} pairs. The  input linkage
--              string contains zero or more strings of "Table,Id" *including
--              double quotes, and delimited themselves comma, Can be used to
--              accelerate  SaveInActivityHistory LinkObjectToActivityHistory
--              insertion.
-- =============================================
create function [dbo].[fn_Links] (@text varchar(max))   
returns @links table (  
	TableName varchar(50) not null,
	Id int not null
)  
AS  
BEGIN

	-- length
	declare @n int = len(@text);

	-- current index
	declare @i int = 1;

	-- until end of text...
	while @i <= @n begin
		-- expect opening quote at @i
		if substring(@text, @i, 1) != '"' begin
			-- opening quote not found
			break
		end

		-- skip opening quote
		set @i = @i + 1;

		-- find middle comma
		declare @j int = charindex(',', @text, @i);
		if @j = 0 begin
			-- middle comma not found
			break;
		end

		-- find closing quote
		declare @k int = charindex('"', @text, @j + 1);
		if @k = 0 begin
			-- closing quote not found
			break;
		end

		-- table name
		declare @tableName varchar(50) = substring(@text, @i, @j - @i);

		-- skip middle comma
		set @j = @j + 1;

		-- id
		declare @id varchar(max) = substring(@text, @j, @k - @j);

		-- insert {TableName,Id} pair
		insert @links (TableName,Id)
		select @TableName,@id
		-- Note:  isnumeric is roughly equivalent to C++ TryStrToInt validation
		where isnumeric(@id) = 1;

		-- skip closing quote and following comma
		set @i = @k + 2;
    end
    
    return
END
go

-- Set permissions
grant select on fn_Links to DeskflowUsers;

GO
-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 30 Nov 2018
-- Description:	String value with ordinal table valued function.
-- =============================================
create function [dbo].[fn_Strings] (@text varchar(max))   
returns @result table (  
	-- string value
    value varchar(50) not null,
	-- index
	ordinal int primary key not null
)  
AS  
BEGIN

	-- length
	declare @n int = len(@text);

	-- current index
	declare @i int = 1;

	-- index
	declare @m int = 0;

	-- until end of text...
	while @i <= @n begin
		-- find next comma
		declare @j int = charindex(',', @text, @i)

		if @j = 0 begin
			-- last id
			set @j = @n + 1;
		end

		-- populate values
		insert into @result (value, ordinal) values(substring(@text, @i, @j - @i), @m);

		-- advance
		set @i = @j + 1;
		set @m = @m + 1;
    end
    
    return
END
go

-- Set permissions
grant select on [fn_Strings] to DeskflowUsers;

GO

-- =============================================
-- Author:		Nicholas Kooij
-- Create date: 30 Nov 2018
-- Description:	Integer with oridinal table valued function.
-- =============================================
create function [dbo].[fn_Integers] (@text varchar(max))   
returns @result table (  
	-- integer value
    value int not null,
	-- index
	ordinal int primary key not null
)  
AS  
BEGIN

	-- length
	declare @n int = len(@text);

	-- current index
	declare @i int = 1;

	-- index
	declare @m int = 0;

	-- until end of text...
	while @i <= @n begin
		-- find next comma
		declare @j int = charindex(',', @text, @i)

		if @j = 0 begin
			-- last id
			set @j = @n + 1;
		end

		declare @id int = substring(@text, @i, @j - @i);

		-- populate values
		insert into @result (value, ordinal) values(@id, @m);

		-- advance
		set @i = @j + 1;
		set @m = @m + 1;
    end
    
    return
END
GO

-- Set permissions
grant select on [fn_Integers] to DeskflowUsers;


