ALTER TABLE TimeSheets add ShiftBonus money
GO
ALTER TABLE LinkCompaniesToRates add RateDateFrom datetime, RateDateTo datetime, DefaultRate bit
GO
ALTER TABLE LinkCompaniesToRates DISABLE TRIGGER LinkCompaniesToRatesUpdate

update LinkCompaniesToRates 
set RateDateFrom = ShiftTimeFrom,
RateDateTo = ShiftTimeTo,
DefaultRate = 1
from LinkCompaniesToRates JOIN Companies
ON LinkCompaniesToRates.CompaniesID=Companies.CompaniesID
and LinkCompaniesToRates.RateTypesID = Companies.DefaultRateTypesID
where ShiftTimeFrom is not null or
ShiftTimeTo is not null or DefaultRateTypesID>0

ALTER TABLE LinkCompaniesToRates ENABLE TRIGGER LinkCompaniesToRatesUpdate

INSERT INTO LinkCompaniesToRates 
(CompaniesID,RateDateFrom,RateDateTo,RateTypesID, DefaultRate) 
select Companies.CompaniesID,ShiftTimeFrom,ShiftTimeTo,DefaultRateTypesID,1
from Companies 
LEFT JOIN LinkCompaniesToRates
ON LinkCompaniesToRates.CompaniesID=Companies.CompaniesID
and LinkCompaniesToRates.RateTypesID = Companies.DefaultRateTypesID
 where LinkCompaniesToRates.RateTypesID is null and (ShiftTimeFrom is not null or
ShiftTimeTo is not null or DefaultRateTypesID>0)