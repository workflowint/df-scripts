create function fn_getNextPosJobCode (@JobOrdersID int)
returns varchar(50)
as begin
	declare @code varchar(10)
	declare @JobCode varchar(50)
	declare @IntCode int
	select @code = IsNULL(Max(LTRIM(SubString(JobCode,charindex('-',JobCode)+1,datalength(JobCode)))),0) 
	from Positions where JobOrdersID = @JobOrdersID and JobCode like '%-%'
	set @Code = case when @Code ='0' then @Code
					 when datalength(@Code)>1 and @Code like '0%' then substring(@Code,2,datalength(@Code))
					 else @Code end
	set @IntCode = cast(@Code as int) +1			
	set @JobCode = 	LTRIM(RTRIM( str(@JobOrdersID,10)))+'-'+
	case when @IntCode<10 then '0'+LTRIM(RTRIM( str(@IntCode,10))) else LTRIM(RTRIM( str(@IntCode,10))) end
	return @JobCode
end
GO
GRANT EXECUTE ON fn_getNextPosJobCode TO DeskflowUsers