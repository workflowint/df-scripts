set ansi_nulls on
set quoted_identifier on
go

if object_id('fn_wfi_shifts_t') is not null
  drop function fn_wfi_shifts_t
go

create function fn_wfi_shifts_t (
  @FromDate date
  ,@ToDate date
  )
returns table
as
return

select s.JobOrderScheduleID
  ,s.PositionsID
  ,s.JobOrdersID
  ,po.PeopleID
  ,ShiftDate = cast(s.FromDateTime as date)
  ,TimeFrom = s.FromDateTime
  ,TimeTo = s.ToDateTime
  ,Lunch = s.Lunch
  ,ShiftStatus = s.status
  ,s.RateTypesID
  ,RateDescription = r.Description
  ,NumHours = NumHours.val
  ,PayRate = l.PayRateValue
  ,PayTotal = cast(case 
      when r.Daily = 1
        then l.PayRateValue
      else l.PayRateValue * numHours.val
      end as money)
  ,BillRate = l.BillRateValue
  ,BillTotal = cast(case 
      when r.Daily = 1
        then l.BillRateValue
      else l.BillRateValue * numHours.val
      end as money)
  ,IsFilled = case 
    when s.PositionsID > 0
      then 1
    else 0
    end
  ,IsCanceled = ss.HiddenFromProvider
  ,IsScheduled = case 
    when po.PeopleID > 0
      and isnull(ss.HiddenFromProvider, 0) = 0
      and isnull(s.UserStatus, 0) <> 2
      then 1
    else 0
    end
  ,ShiftAddedByProvider = case 
    when s.UserStatus = 1
      then 1
    else 0
    end
  ,ShiftRemovedByProvider = case 
    when s.UserStatus = 2
      then 1
    else 0
    end
  ,j.WLApprovalID
  ,s.AddressesID
from JobOrderSchedule s
left join ScheduleStatus ss on ss.ScheduleStatus = s.status
left join Positions po on po.PositionsID = s.PositionsID
left join JobOrders j on j.jobordersid = po.JobOrdersID
left join RateTypes r on r.RateTypesID = s.RateTypesID
left join LinkPositionsToRates l on l.PositionsID = s.PositionsID
  and l.RateTypesID = r.RateTypesID
outer apply (
  select (DATEDIFF(MINUTE, s.FromDateTime, s.ToDateTime) - ISNULL(s.Lunch, 0)) / 
    60.0
  ) numHours(val)
where CAST(s.FromDateTime as date) between @FromDate
    and @ToDate
go

grant select
  on fn_wfi_shifts_t
  to DeskflowUsers
go








if object_id('fn_wfi_ts_t') is not null
  drop function fn_wfi_ts_t
go

create function fn_wfi_ts_t (
  @FromDate date
  ,@ToDate date
  )
returns table
as
return

select ts.TimeSheetsID
  ,ts.JobOrderScheduleID
  ,ts.PositionsID
  ,ShiftDate = cast(s.FromDateTime as date)
  ,TimeFrom = ts.DateFromInclusive
  ,TimeTo = ts.DateToInclusive
  ,TimesheetStatus = case 
    when ts.DateProcessed is not null
      then 'Processed'
    when ts.DateApproved is not null
      then 'Approved'
    when ts.TempApprovedDate is not null
      then 'Submitted'
    else 'Entered'
    end
  ,ts.TempApprovedDate
  ,ts.DateApproved
  ,ts.DateProcessed
  ,r.RateTypesID
  ,RateDescription = r.Description
  ,NumHours = ts.AmountHours
  ,PayRate = ts.Rate1Value
  ,PayTotal = ts.TotalAmount
  ,BillRate = ts.BillRate1Value
  ,BillTotal = ts.TotalToBill
  ,ts.ApprovedPeopleID
from Timesheets ts
join JobOrderSchedule s on s.JobOrderScheduleID = ts.JobOrderScheduleID
left join RateTypes r on r.RateTypesID = ts.RateTypes1
left join LinkPositionsToRates l on l.PositionsID = ts.PositionsID
  and l.RateTypesID = r.RateTypesID
where CAST(s.FromDateTime as date) between @FromDate
    and @ToDate
go

grant select
  on fn_wfi_ts_t
  to DeskflowUsers
go

















if object_id('fn_wfi_timeEntries_t') is not null
  drop function fn_wfi_timeEntries_t
go

create function fn_wfi_timeEntries_t (
  @FromDate date
  ,@ToDate date
  )
returns table
as
return

select s.JobOrderScheduleID
  ,s.PositionsID
  ,s.JobOrdersID
  ,s.PeopleID
  ,ts.TimeSheetsID
  ,s.ShiftDate
  ,s.Lunch
  ,s.ShiftStatus
  ,s.ShiftAddedByProvider
  ,s.WLApprovalID
  ,s.AddressesID
  ,ts.TempApprovedDate
  ,ts.DateApproved
  ,ts.DateProcessed
  ,ts.ApprovedPeopleID
  ,tsOrShift.*
from dbo.fn_wfi_shifts_t(@FromDate, @ToDate) s
left join dbo.fn_wfi_ts_t(@FromDate, @ToDate) ts on ts.JobOrderScheduleID = s.
  JobOrderScheduleID
outer apply (
  select s.TimeFrom
    ,s.TimeTo
    ,s.NumHours
    ,TimesheetStatus = 'Missing'
    ,s.RateTypesID
    ,s.RateDescription
  where ts.TimeSheetsID is null
  
  union all
  
  select ts.TimeFrom
    ,ts.TimeTo
    ,ts.NumHours
    ,ts.TimesheetStatus
    ,s.RateTypesID
    ,ts.RateDescription
  where ts.TimeSheetsID is not null
  ) tsOrShift
where s.IsScheduled = 1
go

grant select
  on fn_wfi_timeEntries_t
  to DeskflowUsers
go








begin try
  drop function fn_wfi_cls_rates
end try

begin catch
end catch
go

create function fn_wfi_cls_rates (
  @PositionsID int
  ,@BillOrPay varchar(255)
  ,@Separator varchar(max)
  )
returns varchar(max)
as
begin
  declare @Lines table (
    id int identity primary key
    ,Line varchar(max)
    )
  declare @numLines int

  insert into @Lines (Line)
  select RegularText = RateTypes.Description + char(9) + '$' + convert(varchar(31), 
      RateToUse.Rate)
  from RateTypes
  join LinkPositionsToRates LPTR on LPTR.RateTypesID = RateTypes.RateTypesID
    and LPTR.PositionsID = @PositionsID
  outer apply (
    select case 
        when @BillOrPay = 'Bill'
          then LPTR.BillRateValue
        when @BillOrPay = 'Pay'
          then LPTR.PayRateValue
        else null
        end
    ) RateToUse(Rate)
  order by RateTypes.Description
    ,RateTypes.RateTypesID

  set @numLines = @@ROWCOUNT

  declare @Result varchar(max) = ''
  declare @LineID int = 1

  while @LineID <= @numLines
  begin
    set @Result = @Result + @Separator + (
        select isnull(Line, '')
        from @Lines
        where id = @LineID
        )
    set @LineID = @LineID + 1
  end

  return STUFF(@result, 1, len(replace(@Separator, ' ', '.')), '')
end
go

grant execute
  on fn_wfi_cls_rates
  to DeskflowUsers
go












BEGIN TRY DROP FUNCTION fn_wfi_formatDate END TRY BEGIN CATCH END CATCH
GO

CREATE FUNCTION fn_wfi_formatDate(@dt datetime, @Format varchar(31))
RETURNS varchar(255)
AS BEGIN
	DECLARE @YYYY varchar(31), @YY varchar(31),
	@MON varchar(31), @MM varchar(31), @M varchar(31), @MON3 varchar(31),
	@WKDAY varchar(31), @WKDAY3 varchar(31), @DD varchar(31), @D varchar(31),
	@HH24 varchar(31), @H24 varchar(31), @HH12 varchar(31), @H12 varchar(31),
	@minmin varchar(31), @min varchar(31),
	@ampm varchar(31), @ampmdots varchar(31)
	
	DECLARE @Yval int, @Mval int, @Hval int, @H12val int, @Minval int
	
	DECLARE @Result varchar(255)
	
	SET @Yval = DATEPART(year, @dt)
	SET @Mval = DATEPART(month, @dt)
	SET @Hval = DATEPART(hour, @dt)
	SET @H12val = @Hval % 12
	if @H12val = 0
		SET @H12val = 12
	SET @Minval = DATEPART(minute, @dt)
	
	SET @YYYY = DATENAME(year, @dt)
	SET @YY = RIGHT(@YYYY, 2)
	SET @MON = DATENAME(month, @dt)
	SET @MON3 = LEFT(@Mon, 3)
	SET @M = CAST(@Mval as varchar(31))
	SET @MM = right('0' + @M, 2)
	SET @WKDAY = DATENAME(WEEKDAY, @dt)
	SET @WKDAY3 = LEFT(@WKDAY, 3)
	SET @D = DATENAME(day, @dt)
	SET @DD = RIGHT('0' + @D, 2)
	
	SET @H24 = CAST(@Hval as varchar(31))
	SET @HH24 = RIGHT('0' + @H24, 2)
	SET @ampm = CASE WHEN @Hval >= 12 THEN 'pm' ELSE 'am' END
	SET @ampmdots = CASE WHEN @Hval = 12 THEN 'p.m.' ELSE 'a.m.' END
	SET @H12 = CAST(@H12val as varchar(31))
	SET @HH12 = RIGHT('0' + @H12, 2)
	
	SET @min = DATENAME(MINUTE, @dt)
	SET @minmin = RIGHT('0' + @min, 2)
	
	if @Format = 'h(:minmin)am'
		set @Result = @H12 + CASE WHEN @Minval > 0 THEN ':' + @minmin ELSE '' END + @ampm
	else begin
		SET @Result = @Format
		SET @Result = REPLACE(@Result, 'YYYY', '~')
		SET @Result = REPLACE(@Result, 'YY', '!')
		SET @Result = REPLACE(@Result, 'Mon3', '@')
		SET @Result = REPLACE(@Result, 'Mon', '#')
		SET @Result = REPLACE(@Result, 'MM', '$')
		SET @Result = REPLACE(@Result, 'minmin', '%')
		SET @Result = REPLACE(@Result, 'min', '^')
		SET @Result = REPLACE(@Result, 'ampmdots', '&')
		SET @Result = REPLACE(@Result, 'ampm', '*')
		SET @Result = REPLACE(@Result, 'wkday3', '(')
		SET @Result = REPLACE(@Result, 'wkday', ')')
		SET @Result = REPLACE(@Result, 'hh24', '_')
		SET @Result = REPLACE(@Result, 'hh12', '+')
		SET @Result = REPLACE(@Result, 'h24', '`')
		SET @Result = REPLACE(@Result, 'h12', '|')
		SET @Result = REPLACE(@Result, 'dd', '{')
		SET @Result = REPLACE(@Result, 'm', '}')
		SET @Result = REPLACE(@Result, 'd', '[')
		SET @Result = REPLACE(@Result, '~', @YYYY)
		SET @Result = REPLACE(@Result, '!', @YY)
		SET @Result = REPLACE(@Result, '@', @MON3)
		SET @Result = REPLACE(@Result, '#', @Mon)
		SET @Result = REPLACE(@Result, '$', @MM)
		SET @Result = REPLACE(@Result, '%', @minmin)
		SET @Result = REPLACE(@Result, '^', @min)
		SET @Result = REPLACE(@Result, '&', @ampmdots)
		SET @Result = REPLACE(@Result, '*', @ampm)
		SET @Result = REPLACE(@Result, '(', @WKDAY3)
		SET @Result = REPLACE(@Result, ')', @wkday)
		SET @Result = REPLACE(@Result, '_', @hh24)
		SET @Result = REPLACE(@Result, '+', @hh12)
		SET @Result = REPLACE(@Result, '`', @h24)
		SET @Result = REPLACE(@Result, '|', @h12)
		SET @Result = REPLACE(@Result, '{', @dd)
		SET @Result = REPLACE(@Result, '}', @m)
		SET @Result = REPLACE(@Result, '[', @d)
	end
	
	RETURN @Result
END
GO

GRANT EXECUTE ON fn_wfi_formatDate to DeskflowUsers
go












begin try
  drop function fn_wfi_ts_formatTimeRange
end try

begin catch
end catch
go

create function fn_wfi_ts_formatTimeRange (
  @From datetime
  ,@To datetime
  )
returns varchar(255)
as
begin
  return dbo.fn_wfi_formatDate(@From, 'mon3 dd, yyyy') + char(9) + dbo.fn_wfi_formatDate
    (@From, 'h(:minmin)am') + ' - ' + dbo.fn_wfi_formatDate(@To, 'h(:minmin)am')
end
go

grant execute
  on fn_wfi_ts_formatTimeRange
  to DeskflowUsers
go














if object_id('fn_Drew_UTCToUsrTime_SQL2016_t') is not null
  drop function fn_Drew_UTCToUsrTime_SQL2016_t
go

create function dbo.fn_Drew_UTCToUsrTime_SQL2016_t (
  @Date datetime2
  ,@Usr varchar(31)
  ,@IsUTC bit
  )
returns table
as
return

select Value = case 
    when isnull(@IsUtc, 0) = 0
      then @Date
    when UserList.TimeZoneData is null
      then @Date
    else cast(@Date at time zone 'UTC' at time zone UserList.TimeZoneData as datetime)
    end
from UserList
where UserList.LoginName = @Usr
go

grant select
  on dbo.fn_Drew_UTCToUsrTime_SQL2016_t
  to DeskflowUsers
go
















if OBJECT_ID('fn_Drew_UTCToUsrTime_SQL2016', 'fn') is not null
  drop function fn_Drew_UTCToUsrTime_SQL2016
go

create function dbo.fn_Drew_UTCToUsrTime_SQL2016 (
  @Date datetime2
  ,@Usr varchar(31)
  ,@IsUTC bit
  )
returns datetime
as
begin
  declare @tz varchar(80)

  set @tz = (
      select TimeZoneData
      from UserList with (nolock)
      where LoginName = @Usr
      )

  if @IsUTC = 0
    or @tz is null
    return @Date

  return cast(@Date at time zone 'UTC' at time zone @tz as datetime)
end
go

grant execute
  on dbo.fn_Drew_UTCToUsrTime_SQL2016
  to DeskflowUsers
go















if object_id('fn_wfi_lastBillingPeriod_t') is not null
  drop function fn_wfi_lastBillingPeriod_t
go

create function fn_wfi_lastBillingPeriod_t ()
returns @Result table (
  FromDate date
  ,ToDate date
  )
as
begin
  declare @today date = dbo.fn_Drew_UTCToUsrTime_SQL2016(getutcdate(), suser_sname(), 
      1)
  declare @sundayWeekday int = 1
  declare @currentWeekday int = datepart(WEEKDAY, @today)
  declare @subtractDays int = @currentWeekday - @sundayWeekday

  if @currentWeekday = 1
    set @subtractDays = 7

  declare @bpEnd date = dateadd(day, - @subtractDays, @today)
  declare @bpStart date = dateadd(day, - 6, @bpEnd)

  insert @Result (
    FromDate
    ,ToDate
    )
  values (
    @bpStart
    ,@bpEnd
    )

  return;
end
go

grant select
  on fn_wfi_lastBillingPeriod_t
  to DeskflowUsers
go

















if object_id('fn_wfi_timeSummaryByStatus_t', 'tf') is not null
  drop function fn_wfi_timeSummaryByStatus_t
go

create function fn_wfi_timeSummaryByStatus_t (@PositionsID int, @FromDate date, @ToDate date)
returns @Report table (
  TimeEntriesNotSubmitted varchar(max),
  TimesheetsSubmitted varchar(max)
  ,TimesheetsApproved varchar(max)
  ,SubmittedOn varchar(255)
  ,ApprovedOn varchar(255)
  )
as
begin
  declare @numLines int
  declare @te table (
    id int identity primary key
    ,TimesheetStatus nvarchar(50)
    ,TempApprovedDate datetime
    ,DateApproved datetime
    ,RateDescription nvarchar(50)
    ,RangeText varchar(255)
    ,HoursText varchar(255)
    )

  insert into @te (
    TimesheetStatus
    ,TempApprovedDate
    ,DateApproved
    ,RateDescription
    ,RangeText
    ,HoursText
    )
  select 
   TimesheetStatus
    ,TempApprovedDate
    ,DateApproved
    ,RateDescription
    ,dbo.fn_wfi_ts_formatTimeRange(ts.TimeFrom, ts.TimeTo)
    ,ht.val
  from dbo.fn_wfi_timeEntries_t(@FromDate, @ToDate) ts
  outer apply (
    select floor(NumHours)
      ,round((NumHours - floor(numHours)) * 60, 0)
    ) t(h, m)
  outer apply (
    select cast(t.h as varchar(255)) + ':' + right('00' + cast(t.m as varchar(255)), 2)
    ) ht(val)
  where ts.PositionsID = @PositionsID
  order by TimeFrom

  set @numLines = @@ROWCOUNT

  declare @Separator varchar(255) = char(13) + char(10)
  declare @Submitted varchar(max) = ''
  declare @Approved varchar(max) = ''
  declare @NotSubmitted varchar(max) = ''
  declare @Line varchar(max)
  declare @Status varchar(max)
  declare @LineID int = 1

  while @LineID <= @numLines
  begin
    select @Line = isnull(RangeText, '') + ' (' + isnull(HoursText, '') + ')' + char(9) + isnull(RateDescription, '')
      ,@Status = TimesheetStatus
    from @te
    where id = @LineID

    if @Status in('Missing', 'Entered')
      set @NotSubmitted = @NotSubmitted + @Separator + @Line

    if @Status = 'Approved'
      set @Approved = @Approved + @Separator + @Line

    if @Status = 'Submitted'
      set @Submitted = @Submitted + @Separator + @Line

    set @LineID = @LineID + 1
  end

  insert @Report (
TimeEntriesNotSubmitted,  
    TimesheetsApproved
    ,TimesheetsSubmitted
    ,ApprovedOn
    ,SubmittedOn
    )
  select 
  stuff(@NotSubmitted, 1, len(@separator), '')
  ,stuff(@Approved, 1, len(@separator), '')
  ,stuff(@Submitted, 1, len(@Separator), '')
  
    ,(
      select dbo.fn_wfi_formatDate(max(DateApproved), 'mon3 dd yyyy')
      from @te
      )
    ,(
      select dbo.fn_wfi_formatDate(max(TempApprovedDate), 'mon3 dd yyyy')
      from @te
      )

  return
end
go

grant select
  on fn_wfi_timeSummaryByStatus_t
  to DeskflowUsers
go
























if object_id('fn_wfi_timeSummariesForLbp_t', 'tf') is not null
  drop function fn_wfi_timeSummariesForLbp_t
go

create function fn_wfi_timeSummariesForLbp_t (@PositionsID int)
returns @Report table (
  TimeEntriesNotSubmitted varchar(max)
  ,TimesheetsSubmitted varchar(max)
  ,TimesheetsApproved varchar(max)
  ,SubmittedOn varchar(255)
  ,ApprovedOn varchar(255)
  )
as
begin
  declare @FromDate date
    ,@ToDate date

  select @FromDate = FromDate
    ,@ToDate = ToDate
  from dbo.fn_wfi_lastBillingPeriod_t()

  insert @Report (
    TimeEntriesNotSubmitted
    ,TimesheetsApproved
    ,TimesheetsSubmitted
    ,ApprovedOn
    ,SubmittedOn
    )
  select TimeEntriesNotSubmitted
    ,TimesheetsApproved
    ,TimesheetsSubmitted
    ,ApprovedOn
    ,SubmittedOn
  from dbo.fn_wfi_timeSummaryByStatus_t(@PositionsID, @FromDate, @ToDate)

  return
end
go

grant select
  on fn_wfi_timeSummariesForLbp_t
  to DeskflowUsers
go












begin try
  drop function fn_wfi_cls_dates_t
end try

begin catch
end catch
go

create function fn_wfi_cls_dates_t (
  @PositionsID int
  ,@IncludePast bit
  )
returns @Dates table (
  id int identity primary key
  ,FromDateTime datetime
  ,ToDateTime datetime
  ,Lunch int
  )
as
begin
  declare @CurrentDateLocal date = dbo.fn_Drew_UTCToUsrTime_SQL2016(getutcdate(), 
      suser_sname(), 1)

  insert @Dates (
    FromDateTime
    ,ToDateTime
    ,Lunch
    )
  select FromDateTime
    ,ToDateTime
    ,s.Lunch
  from JobOrderSchedule s
  left join ScheduleStatus ss on ss.ScheduleStatus = s.status
  where s.PositionsID = @PositionsID
    and (
      isnull(@IncludePast, 0) = 1
      or datediff(day, @CurrentDateLocal, FromDateTime) >= 0
      )
    and isnull(ss.HiddenFromProvider, 0) = 0
  order by s.FromDateTime

  return
end
go

grant select
  on fn_wfi_cls_dates_t
  to DeskflowUsers
go















begin try
  drop function fn_wfi_cls_dates
end try

begin catch
end catch
go

create function fn_wfi_cls_dates (
  @PositionsID int
  ,@IncludePast bit
  ,@DateFormat varchar(255)
  ,@TimeFormat varchar(255)
  ,@Separator varchar(max)
  )
returns varchar(max)
as
begin
  declare @Dates table (
    id int primary key
    ,FromDateTime datetime
    ,ToDateTime datetime
    ,Lunch int
    )
  declare @numDates int

  insert @Dates (
    id
    ,FromDateTime
    ,ToDateTime
    ,Lunch
    )
  select id
    ,FromDateTime
    ,ToDateTime
    ,Lunch = case 
      when Lunch > 1
        then Lunch
      else 0
      end
  from dbo.fn_wfi_cls_dates_t(@PositionsID, @IncludePast)

  set @numDates = @@ROWCOUNT

  declare @Result varchar(max) = ''
  declare @from datetime
    ,@to datetime
    ,@lunch int
    ,@blockFrom datetime
    ,@blockToStart datetime
    ,@blockToEnd datetime
    ,@lastFrom datetime
    ,@lastLunch int

  select @lastFrom = FromDateTime
    ,@lastLunch = Lunch
    ,@blockFrom = FromDateTime
    ,@blockToStart = FromDateTime
    ,@blockToEnd = ToDateTime
  from @Dates
  where id = 1

  declare @LineID int = 1

  while @LineID <= @numDates + 1
  begin
    set @lastFrom = @from
    set @lastLunch = @lunch

    select @from = FromDateTime
      ,@to = ToDateTime
      ,@lunch = Lunch
    from @Dates
    where id = @LineID

    declare @bfMins int = datepart(hour, @blockFrom) * 60 + datepart(minute, @blockFrom)
    declare @btMins int = datepart(hour, @blockToEnd) * 60 + datepart(minute, @blockToEnd)
    declare @fMins int = datepart(hour, @from) * 60 + datepart(minute, @from)
    declare @tMins int = datepart(hour, @to) * 60 + datepart(minute, @to)

    if @LineID > @numDates
      or @lastLunch <> @lunch
      or datediff(day, @lastFrom, @from) > 1
      or @bfMins <> @fMins
      or @btMins <> @tMins
    begin
      set @Result = @Result + @Separator + dbo.fn_wfi_formatDate(@blockFrom, 
          @DateFormat)

      if datediff(day, @blockFrom, @blockToStart) > 0
        set @Result = @Result + ' - ' + dbo.fn_wfi_formatDate(@blockToStart, 
            @DateFormat)
      set @Result = @Result + char(9) + dbo.fn_wfi_formatDate(@blockFrom, @TimeFormat) + 
        ' - ' + dbo.fn_wfi_formatDate(@blockToEnd, @TimeFormat)

      if @lastLunch > 0
        set @Result = @Result + ' ' + cast(@lastLunch as varchar(255)) + ' min lunch'
      set @blockFrom = @from
    end

    set @blockToStart = @from
    set @blockToEnd = @to
    set @LineID = @LineID + 1
  end

  return STUFF(@result, 1, len(replace(@Separator, ' ', '.')), '')
end
go

grant execute
  on fn_wfi_cls_dates
  to DeskflowUsers
go
















if object_id('fn_wfi_timesheetsForEntryReminder') is not null
  drop function fn_wfi_timesheetsForEntryReminder
go

create function fn_wfi_timesheetsForEntryReminder (
  @PeopleID int
  ,@FromDate date
  ,@ToDate date
  )
returns varchar(max)
as
begin
  declare @ts table (
    id int identity primary key
    ,TimesheetStatus nvarchar(50)
    ,TempApprovedDate datetime
    ,DateApproved datetime
    ,RateDescription nvarchar(50)
    ,RangeText varchar(255)
    ,JobOrdersID int
    )
  declare @numlines int

  insert into @ts (
    TimesheetStatus
    ,TempApprovedDate
    ,DateApproved
    ,RateDescription
    ,RangeText
    ,JobOrdersID
    )
  select TimesheetStatus
    ,TempApprovedDate
    ,DateApproved
    ,RateDescription
    ,dbo.fn_wfi_ts_formatTimeRange(ts.TimeFrom, ts.TimeTo)
    ,ts.JobOrdersID
  from dbo.fn_wfi_timeEntries_t(@FromDate, @ToDate) ts
  where ts.PeopleID = @PeopleID
  order by JobOrdersID
    ,TimeFrom

  set @numLines = @@ROWCOUNT

  declare @numJobs int
  declare @jobs table (
    id int identity primary key
    ,JobOrdersID int
    ,CompanyName varchar(255)
    ,Specialty varchar(255)
    )

  insert @jobs (
    JobOrdersID
    ,CompanyName
    ,Specialty
    )
  select jobIds.id
    ,c.company
    ,j.JobTitle
  from (
    select distinct JobOrdersID
    from @ts
    where TimesheetStatus in (
        'missing'
        ,'entered'
        )
    ) jobIds(id)
  join JobOrders j on j.JobOrdersID = jobIds.id
  join companies c on c.CompaniesID = j.CompaniesID

  set @numJobs = @@ROWCOUNT

  declare @personText varchar(max) = ''
  declare @nl varchar(255) = char(13) + char(10)
  declare @jobLineNum int = 1

  while @jobLineNum <= @numJobs
  begin
    declare @JobOrdersID int
      ,@jobText varchar(max)

    select @JobOrdersID = jobOrdersID
      ,@jobText = CompanyName + ' - ' + Specialty
    from @jobs
    where id = @jobLineNum

    set @jobText = @jobText + @nl

    declare @tsId int
      ,@tsToId int

    select @tsId = min(id)
      ,@tsToId = max(id)
    from @ts
    where jobordersid = @JobOrdersID

    while @tsId <= @tsToId
    begin
      declare @TsLine varchar(max)

      select @TsLine = RangeText + case 
          when RateDescription is not null
            then ' (' + RateDescription + ')'
          else ''
          end + char(9) + case 
          when TimesheetStatus in (
              'Missing'
              ,'Entered'
              )
            then 'Missing'
          else 'Submitted'
          end
      from @ts
      where id = @tsId

      set @jobText = @jobText + @nl + @TsLine
      set @tsId = @tsId + 1
    end

    set @personText = @personText + @nl + @nl + @jobText
    set @jobLineNum = @jobLineNum + 1
  end

  declare @Result varchar(max) = stuff(@personText, 1, len(@nl) * 2, '')

  return @result
end
go

grant execute
  on dbo.fn_wfi_timesheetsForEntryReminder
  to DeskflowUsers
go













BEGIN TRY DROP FUNCTION Sep END TRY BEGIN CATCH END CATCH
GO

CREATE FUNCTION Sep(@L varchar(max), @Sep varchar(31), @R varchar(max))
RETURNS varchar(max)
AS BEGIN
	DECLARE @LNN varchar(max) = ISNULL(@L, '')
	DECLARE @RNN varchar(max) = ISNULL(@R, '')
	DECLARE @Result varchar(max)
	SET @Result = CASE
		WHEN LEN(@LNN) > 0 AND LEN(@RNN) > 0 THEN @LNN + @Sep + @RNN
		WHEN LEN(@LNN) > 0 THEN @LNN
		WHEN LEN(@RNN) > 0 THEN @RNN
		ELSE ''
		END
	RETURN @Result
END
GO

GRANT EXECUTE ON Sep TO DeskflowUsers
go

















BEGIN TRY DROP FUNCTION fn_Drew_LikelyFacilityAddressID END TRY BEGIN CATCH END CATCH
GO

CREATE FUNCTION fn_Drew_LikelyFacilityAddressID(@JobOrdersID int)
RETURNS TABLE
AS RETURN
	SELECT TOP 1 Facility.AddressesID
	FROM LinkAddressToMCRContract LFacility WITH(NOLOCK)
	JOIN Addresses Facility WITH(NOLOCK)
		ON Facility.AddressesID = LFacility.AddressesID
	WHERE LFacility.JobOrdersID = @JobOrdersID
	ORDER BY ISNULL(DefaultFacility, 0) DESC, Facility.AddressesID
GO

GRANT SELECT ON fn_Drew_LikelyFacilityAddressID TO DeskflowUsers
GO

