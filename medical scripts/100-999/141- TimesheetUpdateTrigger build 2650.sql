CREATE TRIGGER [dbo].[TimesheetsUpdate] ON [dbo].[TimeSheets]
FOR UPDATE 
AS
BEGIN
UPDATE Timesheets
SET  
	Timesheets.TotalAmount = CASE 
	when RateTypes.Daily = 1 then LinkPositionsToRates.PayRateValue+IsNull(Timesheets.ShiftBonus,0)
	else LinkPositionsToRates.PayRateValue*Timesheets.HoursType1+ IsNull(Timesheets.ShiftBonus,0)
	END,
		Timesheets.TotalToBill = CASE 
	when RateTypes.Daily = 1 then LinkPositionsToRates.BillRateValue+IsNull(Timesheets.ShiftBonusBill,0)
	else LinkPositionsToRates.BillRateValue*Timesheets.HoursType1+ IsNull(Timesheets.ShiftBonusBill,0)
	END
FROM Timesheets JOIN Inserted 
ON Timesheets.TimesheetsID=Inserted.TimesheetsID
JOIN Deleted ON
Inserted.TimesheetsID = Deleted.TimesheetsID
JOIN LinkPositionsToRates ON
(LinkPositionsToRates.RateTypesID = TimeSheets.RateTypes1 AND
LinkPositionsToRates.PositionsID = TimeSheets.PositionsID AND
LinkPositionsToRates.CompaniesID = Inserted.CompaniesID)
JOIN RateTypes ON (Timesheets.RateTypes1 =RateTypes.RateTypesID)
WHERE IsNULL(Inserted.CompaniesID,0) <> IsNULL(Deleted.CompaniesID,0)
and TimeSheets.DateProcessed is null 
END 
