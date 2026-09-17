set ansi_nulls on
set quoted_identifier on
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
left join Addresses a on a.AddressesID = s.AddressesID
left join RateTypes r on r.RateTypesID = ts.RateTypes1
    left join LinkPositionsToRates l on l.PositionsID = ts.PositionsID
  and l.RateTypesID = r.RateTypesID
  and l.CompaniesID = a.CompaniesID
where CAST(s.FromDateTime as date) between @FromDate
    and @ToDate
go

grant select
  on fn_wfi_ts_t
  to DeskflowUsers
go

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
left join Addresses a on a.AddressesID = s.AddressesID
left join ScheduleStatus ss on ss.ScheduleStatus = s.status
left join Positions po on po.PositionsID = s.PositionsID
left join JobOrders j on j.jobordersid = po.JobOrdersID
left join RateTypes r on r.RateTypesID = s.RateTypesID
left join LinkPositionsToRates l on l.PositionsID = s.PositionsID
  and l.RateTypesID = r.RateTypesID
  and l.CompaniesID = a.CompaniesID
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
