ALTER TABLE People add LastAHIsUTCTime smallint
GO
/****** Object:  Trigger [dbo].[ActivityHistoryUpdate]    Script Date: 10/03/2019 12:00:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[ActivityHistoryUpdate] ON [dbo].[ActivityHistory]
FOR UPDATE 
NOT FOR REPLICATION 
AS
SET NOCOUNT ON;

--Update AH info
UPDATE ActivityHistory
SET ActivityHistory.UpdatedBy = suser_sname(),
ActivityHistory.UpdatedOn = GETUTCDATE(), 
ActivityHistory.UTCUpdatedOn=1
FROM ActivityHistory JOIN Inserted
ON ActivityHistory.ActivityHistoryID = Inserted.ActivityHistoryID 

UPDATE ActivityHistory
SET ActivityHistory.IsUTCTime = 1
FROM ActivityHistory JOIN Inserted ON ActivityHistory.ActivityHistoryID = Inserted.ActivityHistoryID 
JOIN deleted ON inserted.ActivityHistoryID = deleted.ActivityHistoryID
WHERE IsNull(ActivityHistory.IsUTCTime,0) =0 and 
 	(	deleted.CompletedOn <> inserted.CompletedOn
		OR (deleted.CompletedOn IS NULL AND inserted.CompletedOn IS NOT NULL)
		OR (deleted.CompletedOn IS NOT NULL AND inserted.CompletedOn IS NULL))
 

DECLARE @DataTable table
(	ProjectsID int,
	PeopleID int,
	ActivityHistoryID int,
	CompletedOn datetime,
	IsUTCTime smallint
)
--For each AH where the date was changed, find the people whose lastAH (or lastAH date) changed and fix it
--Can get duplicate rows but not a problem
INSERT INTO @DataTable (PeopleID, ActivityHistoryID, CompletedOn,IsUTCTime )
SELECT PeopleAH.LeftID, MostRecentAH.ActivityHistoryID, MostRecentAH.CompletedOn,MostRecentAH.IsUTCTime
FROM inserted
JOIN deleted
	ON deleted.ActivityHistoryID = inserted.ActivityHistoryID
	AND	--only updated rows where date changed
	(	deleted.CompletedOn <> inserted.CompletedOn
		OR (deleted.CompletedOn IS NULL AND inserted.CompletedOn IS NOT NULL)
		OR (deleted.CompletedOn IS NOT NULL AND inserted.CompletedOn IS NULL)
	)
JOIN LinkObjectToActivityHistory PeopleAH WITH(NOLOCK)	--all People linked to updated AHs
	ON PeopleAH.RightID = inserted.ActivityHistoryID
	AND PeopleAH.ObjectTableName = 'People'
JOIN People WITH(NOLOCK)
	ON People.PeopleID = PeopleAH.LeftID
OUTER APPLY	--most recent AH for those people
(	SELECT TOP 1 ActivityHistory.ActivityHistoryID, ActivityHistory.CompletedOn,ActivityHistory.IsUTCTime
	FROM LinkObjectToActivityHistory WITH(NOLOCK)
	JOIN ActivityHistory WITH(NOLOCK)
		ON LinkObjectToActivityHistory.RightID = ActivityHistory.ActivityHistoryID
	WHERE LinkObjectToActivityHistory.ObjectTableName = 'People'
	AND LinkObjectToActivityHistory.LeftID = PeopleAH.LeftID
	ORDER BY ActivityHistory.CompletedOn DESC
) MostRecentAH
WHERE MostRecentAH.ActivityHistoryID <> inserted.ActivityHistoryID	--only update if most recent AH changed
OR MostRecentAH.CompletedOn <> deleted.CompletedOn
OR (MostRecentAH.CompletedOn IS NULL AND inserted.CompletedOn IS NOT NULL)
OR (MostRecentAH.CompletedOn IS NOT NULL AND inserted.CompletedOn IS NULL)

IF @@ROWCOUNT > 0 begin
	UPDATE People
	SET LastAHID = DT.ActivityHistoryID, LastAHCompletedOn = DT.CompletedOn,
	LastAHIsUTCTime = DT.IsUTCTime
	FROM People
	JOIN @DataTable DT
		ON DT.PeopleID = People.PeopleID
	
	DELETE FROM @DataTable
end

--For each AH where the date was changed, find the LastProjectActivitys whose LastAH changed and fix it
INSERT INTO @DataTable (ProjectsID, PeopleID, ActivityHistoryID, CompletedOn)
SELECT DISTINCT ProjectsAH.LeftID, PeopleAH.LeftID, MostRecentAH.ActivityHistoryID, MostRecentAH.CompletedOn
FROM inserted
JOIN deleted
	ON deleted.ActivityHistoryID = inserted.ActivityHistoryID
	AND	--only updated rows where date changed
	(	deleted.CompletedOn <> inserted.CompletedOn
		OR (deleted.CompletedOn IS NULL AND inserted.CompletedOn IS NOT NULL)
		OR (deleted.CompletedOn IS NOT NULL AND inserted.CompletedOn IS NULL)
	)
JOIN LinkObjectToActivityHistory PeopleAH WITH(NOLOCK)	--all People linked to updated AHs
	ON PeopleAH.RightID = inserted.ActivityHistoryID
	AND PeopleAH.ObjectTableName = 'People'
JOIN LinkObjectToActivityHistory ProjectsAH WITH(NOLOCK)	--all Projects linked to updated AHs
	ON ProjectsAH.RightID = inserted.ActivityHistoryID
	AND ProjectsAH.ObjectTableName = 'Projects'
JOIN LastProjectActivity WITH(NOLOCK)	--LastProjectActivitys for the People/Projects linked to updated AHs
	ON LastProjectActivity.PeopleID = PeopleAH.LeftID
	AND LastProjectActivity.ProjectsID = ProjectsAH.LeftID
OUTER APPLY	--most recent AH for those projects/people - NULL if none exist
(	SELECT TOP 1 ActivityHistory.ActivityHistoryID, ActivityHistory.CompletedOn
	FROM LinkObjectToActivityHistory innerProjAH WITH(NOLOCK)
	LEFT JOIN LinkObjectToActivityHistory innerPeopleAH WITH(NOLOCK)
		ON innerProjAH.RightID = innerPeopleAH.RightID
	JOIN ActivityHistory WITH(NOLOCK)
		ON innerProjAH.RightID = ActivityHistory.ActivityHistoryID
	WHERE innerPeopleAH.LeftID = PeopleAH.LeftID
	AND innerProjAH.LeftID = ProjectsAH.LeftID
	AND innerPeopleAH.ObjectTableName = 'People'
	AND innerProjAH.ObjectTableName = 'Projects'
	ORDER BY ActivityHistory.CompletedOn DESC
) MostRecentAH
WHERE MostRecentAH.ActivityHistoryID <> LastProjectActivity.LastProjectAHID	--only update if most recent AH changed
OR MostRecentAH.CompletedOn <> LastProjectActivity.LASTProjectAHDate
OR (MostRecentAH.CompletedOn IS NULL AND LastProjectActivity.LASTProjectAHDate IS NOT NULL)
OR (MostRecentAH.CompletedOn IS NOT NULL AND LastProjectActivity.LASTProjectAHDate IS NULL)

UPDATE LastProjectActivity
SET LastProjectAHID = DT.ActivityHistoryID, LASTProjectAHDate = DT.CompletedOn
FROM LastProjectActivity
JOIN @DataTable DT
	ON DT.ProjectsID = LastProjectActivity.ProjectsID
	AND DT.PeopleID = LastProjectActivity.PeopleID
	
GO

/****** Object:  Trigger [dbo].[DeleteLinkObjectToActivityHistory]    Script Date: 10/03/2019 12:10:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[DeleteLinkObjectToActivityHistory] ON [dbo].[LinkObjectToActivityHistory] 
FOR DELETE
AS
SET NOCOUNT ON;

DECLARE @DataTable table
(	ProjectsID int,
	PeopleID int,
	ActivityHistoryID int,
	CompletedOn datetime,
	IsUTCTime smallint
)

--If we dropped the link between a person and their last AH, update that person's last AH
INSERT INTO @DataTable(PeopleID, ActivityHistoryID, CompletedOn,IsUTCTime)
SELECT deleted.LeftID, MostRecentAH.ActivityHistoryID, MostRecentAH.CompletedOn, MostRecentAH.IsUTCTime 
FROM deleted
JOIN People WITH(NOLOCK) --only get deleted rows where AH is last AH
	ON People.PeopleID = deleted.LeftID
	AND People.LastAHID = deleted.RightID
OUTER APPLY --get NULL values if there is no ActivityHistory linked to the person
(	SELECT TOP 1 ActivityHistory.ActivityHistoryID, ActivityHistory.CompletedOn, ActivityHistory.IsUTCTime
	FROM LinkObjectToActivityHistory WITH(NOLOCK)
	LEFT JOIN ActivityHistory WITH(NOLOCK)
		ON LinkObjectToActivityHistory.RightID = ActivityHistory.ActivityHistoryID
	WHERE LinkObjectToActivityHistory.LeftID = deleted.LeftID
	AND LinkObjectToActivityHistory.ObjectTableName = 'People'
	ORDER BY ActivityHistory.CompletedOn DESC
) MostRecentAH
WHERE deleted.ObjectTableName = 'People'

if @@ROWCOUNT > 0 begin
	UPDATE People
	SET LastAHID = DT.ActivityHistoryID, LastAHCompletedOn = DT.CompletedOn,
	LastAHIsUTCTime = DT.IsUTCTime
	FROM People WITH(NOLOCK)
	JOIN @DataTable DT
		ON DT.PeopleID = People.PeopleID
	
	DELETE FROM @DataTable
end

--If link to person was dropped where the AH was also linked to a project (or vice versa), and that AH was the lastProjectActivity for that person and project,
--update the LastProjectActivity to the new most recent AH.
INSERT INTO @DataTable(PeopleID, ProjectsID, ActivityHistoryID, CompletedOn)
SELECT Link.PeopleID, Link.ProjectsID, MostRecentAH.ActivityHistoryID, MostRecentAH.CompletedOn
FROM
(	--People links deleted that have/had a Project link
	SELECT PeopleID = deleted.LeftID, ProjectLink.ProjectsID, ProjectLink.AHID
	FROM deleted
	CROSS APPLY
	(	SELECT innerD.LeftID, innerD.RightID
		FROM deleted innerD --in case project links were deleted with the people link
		WHERE innerD.RightID = deleted.RightID
		AND innerD.ObjectTableName = 'Projects'
		UNION ALL
		SELECT LeftID, RightID
		FROM LinkObjectToActivityHistory WITH(NOLOCK)
		WHERE LinkObjectToActivityHistory.RightID = deleted.RightID
		AND LinkObjectToActivityHistory.ObjectTableName = 'Projects'
	) ProjectLink(ProjectsID, AHID)
	WHERE deleted.ObjectTableName = 'People'
	
	UNION
	--Project links deleted that have a People link
	SELECT PeopleID = PeopleAH.LeftID, ProjectsID = deleted.LeftID, AHID = deleted.RightID
	FROM deleted
	JOIN LinkObjectToActivityHistory PeopleAH WITH(NOLOCK)
		ON PeopleAH.RightID = deleted.RightID
	WHERE deleted.ObjectTableName = 'Projects'
	AND PeopleAH.ObjectTableName = 'People'
) Link(PeopleID, ProjectsID, AHID)
JOIN LastProjectActivity WITH(NOLOCK)
	ON LastProjectActivity.ProjectsID = Link.ProjectsID
	AND LastProjectActivity.PeopleID = Link.PeopleID
	AND LastProjectActivity.LastProjectAHID = Link.AHID
OUTER APPLY
(	SELECT TOP 1 ActivityHistory.ActivityHistoryID, ActivityHistory.CompletedOn
	FROM LinkObjectToActivityHistory PeopleAH WITH(NOLOCK)
	LEFT JOIN LinkObjectToActivityHistory ProjectsAH WITH(NOLOCK)
		ON PeopleAH.RightID = ProjectsAH.RightID
	LEFT JOIN ActivityHistory WITH(NOLOCK)
		ON ActivityHistory.ActivityHistoryID = PeopleAH.RightID
	WHERE PeopleAH.LeftID = Link.PeopleID
	AND ProjectsAH.LeftID = Link.ProjectsID
	AND PeopleAH.ObjectTableName = 'People'
	AND ProjectsAH.ObjectTableName = 'Projects'
	ORDER BY ActivityHistory.CompletedOn DESC
) MostRecentAH

if @@ROWCOUNT > 0
	UPDATE LastProjectActivity
	SET LastProjectAHID = DT.ActivityHistoryID, LASTProjectAHDate = DT.CompletedOn
	FROM LastProjectActivity
	JOIN @DataTable DT
		ON DT.PeopleID = LastProjectActivity.PeopleID
		AND DT.ProjectsID = LastProjectActivity.ProjectsID

--If link to SCR dropped, delete SCR
DELETE SearchContactRecord
FROM SearchContactRecord
JOIN deleted
	ON deleted.LeftID = SearchContactRecord.SearchContactRecordID
	AND deleted.ObjectTableName = 'SearchContactRecord'
	
--If link to MCR dropped, delete MCR
DELETE MarketingCallReport
FROM MarketingCallReport
JOIN deleted
	ON deleted.LeftID = MarketingCallReport.MarketingCallReportID
	AND deleted.ObjectTableName = 'MarketingCallReport'

GO

/****** Object:  Trigger [dbo].[LinkObjectToActivityHistoryInsert]    Script Date: 10/03/2019 12:14:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[LinkObjectToActivityHistoryInsert] ON [dbo].[LinkObjectToActivityHistory] 
FOR INSERT
AS
SET NOCOUNT ON;

DECLARE @DataTable table
(	ProjectsID int,
	PeopleID int,
	ActivityHistoryID int,
	CompletedOn datetime,
	IsUTCTime smallint,
	HasLastProjectActivity bit
)

--UPDATE People
--whose LastAH info now needs to be updated
--(if there was an AH linked to the person that is more recent than thier current LastAH)
--(only get the most recent AH from the new links)
INSERT INTO @DataTable(PeopleID, ActivityHistoryID, CompletedOn,IsUTCTime)
SELECT RankedAH.PeopleID, RankedAH.ActivityHistoryID, RankedAH.CompletedOn, RankedAH.IsUTCTime
FROM
(	SELECT PeopleID = inserted.LeftID, ActivityHistory.ActivityHistoryID, ActivityHistory.CompletedOn,ActivityHistory.IsUTCTime,
	AHDateRank = ROW_NUMBER() OVER(partition by inserted.LeftID ORDER BY ActivityHistory.CompletedOn DESC)
	FROM inserted
	JOIN ActivityHistory WITH(NOLOCK)
		ON ActivityHistory.ActivityHistoryID = inserted.RightID
	WHERE inserted.ObjectTableName = 'People'
) RankedAH
JOIN People WITH(NOLOCK)
	ON People.PeopleID = RankedAH.PeopleID
WHERE RankedAH.AHDateRank = 1
AND
(	RankedAH.CompletedOn > People.LastAHCompletedOn
	OR People.LastAHCompletedOn IS NULL
)

if @@ROWCOUNT > 0 begin
	UPDATE People
	SET LastAHID = DT.ActivityHistoryID, LastAHCompletedOn = DT.CompletedOn,
	LastAHIsUTCTime = DT.IsUTCTime
	FROM People
	JOIN @DataTable DT
		ON DT.PeopleID = People.PeopleID
	DELETE FROM @DataTable
end

--UPDATE LastProjectActivity
--For people who have a LastProjectActivity that needs to be updated
--(	if any of the inserted People links also link to a project (or vice versa),
--	where a LastProjectActivity exists for that person and project,
--	and the new link is to a more recent Activity)
--(Only get the most recent AH from the new links)
INSERT INTO @DataTable(ProjectsID, PeopleID, ActivityHistoryID, CompletedOn, HasLastProjectActivity)
SELECT RankedAH.ProjectsID, RankedAH.PeopleID, RankedAH.ActivityHistoryID, RankedAH.CompletedOn, HasLPA = CASE WHEN LastProjectActivity.PeopleID IS NOT NULL THEN 1 ELSE 0 END
FROM
(	SELECT PeopleID = PeopleLink.LeftID, ProjectsID = ProjectLink.LeftID, ActivityHistory.ActivityHistoryID, ActivityHistory.CompletedOn,
	AHRank = ROW_NUMBER() OVER(partition by PeopleLink.LeftID, ProjectLink.LeftID ORDER BY ActivityHistory.CompletedOn DESC)
	FROM
	inserted
	JOIN LinkObjectToActivityHistory PeopleLink WITH(NOLOCK)
		ON
		(	inserted.ObjectTableName = 'People'
			AND PeopleLink.RightID = inserted.RightID
			AND PeopleLink.LeftID = inserted.LeftID
			AND PeopleLink.ObjectTableName = 'People'
		) OR
		(	inserted.ObjectTableName = 'Projects'
			AND PeopleLink.RightID = inserted.RightID
			AND PeopleLink.ObjectTableName = 'People'
		)
	JOIN LinkObjectToActivityHistory ProjectLink WITH(NOLOCK)
		ON
		(	inserted.ObjectTableName = 'Projects'
			AND ProjectLink.RightID = inserted.RightID
			AND ProjectLink.LeftID = inserted.LeftID
			AND ProjectLink.ObjectTableName = 'Projects'
		) OR
		(	inserted.ObjectTableName = 'People'
			AND ProjectLink.RightID = inserted.RightID
			AND ProjectLink.ObjectTableName = 'Projects'
		)
	JOIN ActivityHistory WITH(NOLOCK)
		ON ActivityHistory.ActivityHistoryID = inserted.RightID
	WHERE inserted.ObjectTableName IN('Projects', 'People')
) RankedAH --most recent AH that is being linked to, for each person/project combination possibly affected by the insert
LEFT JOIN LastProjectActivity WITH(NOLOCK) --LastProjectActivity, if it exists, for the person/project combination
	ON LastProjectActivity.PeopleID = RankedAH.PeopleID
	AND LastProjectActivity.ProjectsID = RankedAH.ProjectsID
WHERE --Filter out rows that have a LastProjectActivity, where the date is more recent than the most recent AH being linked
(	RankedAH.CompletedOn > LastProjectActivity.LASTProjectAHDate
	OR LastProjectActivity.LASTProjectAHDate IS NULL --This way if there is no LastProjectActivity, the row still stays and LastProjectActivity will be INSERTed
)
AND RankedAH.AHRank = 1

if (select COUNT(1) from @DataTable where HasLastProjectActivity = 1) > 0
	UPDATE LastProjectActivity
	SET LastProjectAHID = DT.ActivityHistoryID, LASTProjectAHDate = DT.CompletedOn
	FROM LastProjectActivity
	JOIN @DataTable DT
		ON DT.PeopleID = LastProjectActivity.PeopleID
		AND DT.ProjectsID = LastProjectActivity.ProjectsID
	WHERE DT.HasLastProjectActivity = 1

if (select COUNT(1) from @DataTable where HasLastProjectActivity = 0) > 0
	INSERT INTO LastProjectActivity(ProjectsID, PeopleID, LastProjectAHID, LASTProjectAHDate)
	SELECT ProjectsID, PeopleID, ActivityHistoryID, CompletedOn
	FROM @DataTable
	WHERE HasLastProjectActivity = 0


GO
ALTER TABLE People DISABLE Trigger PeopleUpdate 
ALTER TABLE People DISABLE Trigger PeopleUpdateWebLogin 
ALTER TABLE People DISABLE Trigger PeopleAudit

update People set LastAHIsUTCTime = ActivityHistory.IsUTCTime
from People JOIN ActivityHistory
ON people.LastAHID = ActivityHistory.ActivityHistoryID 

ALTER TABLE People ENABLE Trigger PeopleUpdate 
ALTER TABLE People ENABLE Trigger PeopleUpdateWebLogin 
ALTER TABLE People ENABLE Trigger PeopleAudit
