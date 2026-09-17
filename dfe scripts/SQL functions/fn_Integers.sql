/****** Object:  UserDefinedFunction [dbo].[fn_Integers]    Script Date: 12/5/2018 11:42:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

