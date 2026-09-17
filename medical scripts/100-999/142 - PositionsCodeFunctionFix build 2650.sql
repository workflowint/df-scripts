/****** Object:  UserDefinedFunction [dbo].[fn_getNextPosJobCode]    Script Date: 2025-02-13 2:31:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fn_getNextPosJobCode] (@JobOrdersID int)
returns varchar(50)
as begin
	declare @JobCode varchar(50)
	declare @IntCode int
	select @Intcode = IsNull(max(cast (LTRIM(SubString(JobCode,charindex('-',JobCode)+1,datalength(JobCode) )) as int) ),0)
	from Positions where JobOrdersID = @JobOrdersID and JobCode like '%-%'
	set @IntCode = @IntCode+1	
	set @JobCode = 	LTRIM(RTRIM( str(@JobOrdersID,10)))+'-'+
	case when @IntCode<10 then '0'+LTRIM(RTRIM( str(@IntCode,10))) else LTRIM(RTRIM( str(@IntCode,10))) end
	return @JobCode
end
