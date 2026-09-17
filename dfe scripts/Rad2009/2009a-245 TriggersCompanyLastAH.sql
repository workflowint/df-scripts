SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

BEGIN TRY DROP TRIGGER ActivityHistory_U_SetCompanyLastAH END TRY BEGIN CATCH END CATCH
GO

CREATE TRIGGER ActivityHistory_U_SetCompanyLastAH
ON ActivityHistory
FOR UPDATE
AS begin
	--Companies where the AH CompletedOn date was changed
	DECLARE @CompanyAHDateChanged table(CompaniesID int)

	INSERT INTO @CompanyAHDateChanged(CompaniesID)
	SELECT DISTINCT L.LeftID
	FROM inserted
	JOIN deleted
		on deleted.ActivityHistoryID = inserted.ActivityHistoryID
	JOIN LinkObjectToActivityHistory L
		ON L.RightID = inserted.ActivityHistoryID
		AND L.ObjectTableName = 'Companies'
	WHERE inserted.CompletedOn <> deleted.CompletedOn
	OR(inserted.CompletedOn IS NULL AND deleted.CompletedOn IS NOT NULL)
	OR(inserted.CompletedOn IS NOT NULL AND deleted.CompletedOn IS NULL)

	--Companies whose last AH was affected by change
	DECLARE @CompaniesLastAHChanged table(CompaniesID int, NewLastAHID int, NewLastAHCompletedOn datetime, NewUTCLastAHCompletedOn int)
	
	INSERT INTO @CompaniesLastAHChanged(CompaniesID, NewLastAHID, NewLastAHCompletedOn, NewUTCLastAHCompletedOn)
	SELECT CompanyAHDateChanged.CompaniesID, LastAH.ActivityHistoryID, LastAH.CompletedOn, LastAH.IsUTCTime
	FROM @CompanyAHDateChanged CompanyAHDateChanged
	CROSS APPLY(
		SELECT TOP 1 AH.ActivityHistoryID, AH.CompletedOn, AH.IsUTCTime
		FROM ActivityHistory AH WITH(NOLOCK)
		JOIN LinkObjectToActivityHistory LComp WITH(NOLOCK)
			ON LComp.RightID = AH.ActivityHistoryID
			AND LComp.ObjectTableName = 'Companies'
		WHERE LComp.LeftID = CompanyAHDateChanged.CompaniesID
		ORDER BY AH.CompletedOn DESC
	) LastAH
	JOIN Companies
		ON Companies.CompaniesID = CompanyAHDateChanged.CompaniesID
	WHERE ( --where last ah id or date has changed
		Companies.LastAHID IS NULL
		OR Companies.LastAHID <> LastAH.ActivityHistoryID
	)
	OR (
		(Companies.LastAHCompletedOn IS NULL AND LastAH.CompletedOn IS NOT NULL)
		OR (Companies.LastAHCompletedOn IS NOT NULL AND LastAH.CompletedOn IS NULL)
		OR (Companies.LastAHCompletedOn <> LastAH.CompletedOn)
	)

	--Apply update
	UPDATE Companies SET LastAHID = NewLastAHID, LastAHCompletedOn = NewLastAHCompletedOn, UTCLastAHCompletedOn = NewUTCLastAHCompletedOn
	FROM @CompaniesLastAHChanged CompaniesLastAHChanged
	WHERE CompaniesLastAHChanged.CompaniesID = Companies.CompaniesID
end

GO

BEGIN TRY DROP TRIGGER LinkObjectToActivityHistory_D_SetCompanyLastAH END TRY BEGIN CATCH END CATCH
GO

CREATE TRIGGER LinkObjectToActivityHistory_D_SetCompanyLastAH ON LinkObjectToActivityHistory
FOR DELETE
AS
SET NOCOUNT ON;

--find companies where a last AH was deleted
DECLARE @CompaniesLastAHDeleted table(CompaniesID int)
INSERT INTO @CompaniesLastAHDeleted(CompaniesID)
SELECT deleted.LeftID
FROM deleted
JOIN Companies
	ON Companies.LastAHID = deleted.RightID
	AND deleted.ObjectTableName = 'Companies'

--find new most recent AH, apply update
UPDATE Companies SET LastAHID = LastAH.ActivityHistoryID, LastAHCompletedOn = LastAH.CompletedOn, UTCLastAHCompletedOn = LastAH.IsUTCTime
FROM @CompaniesLastAHDeleted CompaniesLastAHDeleted
JOIN Companies
	ON Companies.CompaniesID = CompaniesLastAHDeleted.CompaniesID
OUTER APPLY(
	SELECT TOP 1 AH.ActivityHistoryID, AH.CompletedOn, AH.IsUTCTime
	FROM ActivityHistory AH WITH(NOLOCK)
	JOIN LinkObjectToActivityHistory LComp WITH(NOLOCK)
		ON LComp.RightID = AH.ActivityHistoryID
		AND LComp.ObjectTableName = 'Companies'
	WHERE LComp.LeftID = Companies.CompaniesID
	ORDER BY AH.CompletedOn DESC
) LastAH



GO

BEGIN TRY DROP TRIGGER LinkObjectToActivityHistory_I_SetCompanyLastAH END TRY BEGIN CATCH END CATCH
GO

CREATE TRIGGER LinkObjectToActivityHistory_I_SetCompanyLastAH ON LinkObjectToActivityHistory
FOR INSERT
AS
SET NOCOUNT ON;

--update companies where the most recent linked AH is more recent than the LastAH
DECLARE @CompaniesLastAHChanged table(CompaniesID int, NewLastAHID int, NewLastAHCompletedOn datetime, NewUTCLastAHCompletedOn int)
	
INSERT INTO @CompaniesLastAHChanged(CompaniesID, NewLastAHID, NewLastAHCompletedOn, NewUTCLastAHCompletedOn)
SELECT Companies.CompaniesID, LastLinkedAH.ActivityHistoryID, LastLinkedAH.CompletedOn, LastLinkedAH.IsUTCTime
FROM Companies
CROSS APPLY(
	--most recent AH linked to company in this insert
	SELECT TOP 1 AH.ActivityHistoryID, AH.CompletedOn, AH.IsUTCTime
	FROM ActivityHistory AH WITH(NOLOCK)
	JOIN inserted LComp WITH(NOLOCK)
		ON LComp.RightID = AH.ActivityHistoryID
		AND LComp.ObjectTableName = 'Companies'
	WHERE LComp.LeftID = Companies.CompaniesID
	ORDER BY AH.CompletedOn DESC
) LastLinkedAH
WHERE ( --where last linked ah is more recent than existing LastAH
	Companies.LastAHID IS NULL
	OR (Companies.LastAHCompletedOn IS NULL AND LastLinkedAH.CompletedOn IS NOT NULL)
	OR LastLinkedAH.CompletedOn > Companies.LastAHCompletedOn
)

--Apply update
UPDATE Companies SET LastAHID = NewLastAHID, LastAHCompletedOn = NewLastAHCompletedOn, UTCLastAHCompletedOn = NewUTCLastAHCompletedOn
FROM @CompaniesLastAHChanged CompaniesLastAHChanged
WHERE CompaniesLastAHChanged.CompaniesID = Companies.CompaniesID