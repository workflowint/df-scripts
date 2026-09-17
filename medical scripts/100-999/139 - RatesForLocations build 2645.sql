delete LinkPositionsToRates where positionsid = 0
go
ALTER TABLE LinkPositionsToRates add CompaniesID int
GO
ALTER TABLE LinkPositionsToRates DISABLE TRIGGER LinkPositionsToRatesUpdate
UPDATE LinkPositionsToRates
set LinkPositionsToRates.CompaniesID= Positions.CompaniesID
FROM LinkPositionsToRates JOIN  Positions
ON LinkPositionsToRates.PositionsID= Positions.PositionsID
WHERE LinkPositionsToRates.CompaniesID is null
ALTER TABLE LinkPositionsToRates ENABLE TRIGGER LinkPositionsToRatesUpdate
GO
ALTER TABLE LinkPositionsToRates
DROP CONSTRAINT PK_LinkPositionsToRates
GO
ALTER TABLE LinkPositionsToRates ALTER COLUMN CompaniesID int not null
GO
ALTER TABLE LinkPositionsToRates ADD CONSTRAINT PK_LinkPositionsToRatesNew 
PRIMARY KEY CLUSTERED  (PositionsID,RateTypesID,CompaniesID)