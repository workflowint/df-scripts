SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if object_id('fn_wfi_timesheetsForApprovalDocusign') is not null
	drop function fn_wfi_timesheetsForApprovalDocusign
go

create function [dbo].[fn_wfi_timesheetsForApprovalDocusign] (
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
    ,ProviderID int
    )
  declare @numlines int

  insert into @ts (
    TimesheetStatus
    ,TempApprovedDate
    ,DateApproved
    ,RateDescription
    ,RangeText
    ,JobOrdersID
    ,ProviderID
    )
  select TimesheetStatus
    ,TempApprovedDate
    ,DateApproved
    ,RateDescription
    ,dbo.fn_wfi_ts_formatTimeRange(ts.TimeFrom, ts.TimeTo)
    ,ts.JobOrdersID
    ,ts.PeopleID
  from dbo.fn_wfi_timeEntries_t(@FromDate, @ToDate) ts
  where ts.WLApprovalID = @PeopleID
    and ts.TimesheetStatus in (
      'Submitted'
      ,'Approved'
      )
  order by ts.PeopleID
    ,ts.JobOrdersID
    ,TimeFrom

  set @numLines = @@ROWCOUNT

  declare @numJobs int
  declare @jobs table (
    id int identity primary key
    ,JobOrdersID int
    ,ProviderID int
    ,CompanyName varchar(255)
    ,Specialty varchar(255)
    ,ProviderName varchar(511)
    )

  insert @jobs (
    JobOrdersID
    ,ProviderID
    ,CompanyName
    ,Specialty
    ,ProviderName
    )
  select jobIds.JobOrdersID
    ,jobIds.ProviderID
    ,c.company
    ,j.JobTitle
    ,ProviderName = case 
      when len(p.Prefix) > 0
        then p.Prefix + case 
            when p.Prefix like '%.'
              then ''
            else '.'
            end + ' '
      else ''
      end + p.FirstName + ' ' + p.LastName
  from (
    select distinct JobOrdersID
      ,ProviderID
    from @ts
    where TimesheetStatus in ('submitted')
    ) jobIds(JobOrdersID, ProviderID)
  join JobOrders j on j.JobOrdersID = jobIds.JobOrdersID
  join companies c on c.CompaniesID = j.CompaniesID
  join People p on p.PeopleID = jobIds.ProviderID

  set @numJobs = @@ROWCOUNT

  declare @personText varchar(max) = ''
  declare @nl varchar(255) = char(13) + char(10)
  declare @jobLineNum int = 1

  while @jobLineNum <= @numJobs
  begin
    declare @JobOrdersID int
      ,@ProviderID int
      ,@jobText varchar(max)

    select @JobOrdersID = jobOrdersID
      ,@ProviderID = ProviderID
      ,@jobText = ProviderName + ' - ' + Specialty + ' - ' + CompanyName
    from @jobs
    where id = @jobLineNum

    set @jobText = @jobText + @nl

    declare @tsId int
      ,@tsToId int

    select @tsId = min(id)
      ,@tsToId = max(id)
    from @ts
    where jobordersid = @JobOrdersID
      and ProviderID = @ProviderID

    while @tsId <= @tsToId
    begin
      declare @TsLine varchar(max)

      select @TsLine = RangeText + case 
          when RateDescription is not null
            then ' (' + RateDescription + ')'
          else ''
          end + char(9) + TimesheetStatus
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
GO


grant execute on fn_wfi_timesheetsForApprovalDocusign to DeskflowUsers
go
