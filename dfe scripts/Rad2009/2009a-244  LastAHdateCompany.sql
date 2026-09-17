ALTER TABLE Companies add LastAHID int,LastAHCompletedOn datetime, UTCLastAHCompletedOn int
GO
ALTER TABLE Companies DISABLE TRIGGER CompanyUpdate 
ALTER TABLE Companies DISABLE TRIGGER CompaniesAudit 

UPDATE Companies SET LastAHID = LastAH.ActivityHistoryID, LastAHCompletedOn = LastAH.CompletedOn, UTCLastAHCompletedOn = LastAH.IsUTCTime
FROM Companies
CROSS APPLY(
	SELECT TOP 1 AH.ActivityHistoryID, AH.CompletedOn, AH.IsUTCTime
	FROM ActivityHistory AH WITH(NOLOCK)
	JOIN LinkObjectToActivityHistory LComp WITH(NOLOCK)
		ON LComp.RightID = AH.ActivityHistoryID
		AND LComp.ObjectTableName = 'Companies'
	WHERE LComp.LeftID = Companies.CompaniesID
	ORDER BY AH.CompletedOn DESC
) LastAH

ALTER TABLE Companies ENABLE TRIGGER CompanyUpdate 
ALTER TABLE Companies ENABLE TRIGGER CompaniesAudit 
