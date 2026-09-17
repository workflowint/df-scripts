ALTER TABLE ActReport add TableName varchar(50)
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FillActReportTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FillActReportTable]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FillActReportTableForGroup]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FillActReportTableForGroup]
GO
GO
CREATE procedure [dbo].[FillActReportTable] @DateFrom datetime,  @DateTo datetime,
				    @Partner varchar(20),@UserID int	
as
BEGIN 
 
delete from ActReport where SessionID=@@spid
INSERT INTO ActReport ([RecordID],[TypeID],[UserID],
           [DateFrom],[DateTo],[TableName])
SELECT MarketingCallReportID AS RecordID,
'1' AS MType,@UserID,@DateFrom,@DateTo,'MarketingCallReport'
FROM MarketingCallReport  WITH (NOLOCK)  
WHERE AppDate >=@DateFrom and AppDate <=@DateTo
AND ( Partner1 like @Partner OR Partner2 like @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID AS RecordID,
'2' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK) 
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE DateSearchInitiated >=@DateFrom
and DateSearchInitiated <=@DateTo AND ProjectStatus.StatusActive = 1
AND ( Owner1 like @Partner OR Owner2 like @Partner )
UNION
SELECT 
 Opportunities.OpportunitiesID AS RecordID,
'3' AS MType,@UserID,@DateFrom,@DateTo,'Opportunities'
FROM Opportunities WITH (NOLOCK)  
LEFT JOIN LinkOpportunitiesToBusinessObjects WITH (NOLOCK) ON
( Opportunities.OpportunitiesID = LinkOpportunitiesToBusinessObjects.OpportunitiesID)
WHERE ( Manager LIKE @Partner OR Manager IS NULL)
and LinkOpportunitiesToBusinessObjects.OpportunitiesID is null
AND OppDate >=@DateFrom and OppDate <=@DateTo
UNION
SELECT distinct
ActivityHistory.ActivityHistoryID AS RecordID,
'4' AS MType,@UserID,@DateFrom,@DateTo,'ActivityHistory'
FROM ActivityHistory WITH (NOLOCK) 
LEFT JOIN LinkUsersToActivityHistory WITH (NOLOCK)  
ON LinkUsersToActivityHistory.ActivityHistoryID=ActivityHistory.ActivityHistoryID 
WHERE LinkUsersToActivityHistory.LoginName like @Partner
AND ActivityHistory.Type like 'Marketing Activit%' and CompletedOn >=@DateFrom
and CompletedOn <=@DateTo
UNION
SELECT DISTINCT Positions.PositionsID AS RecordID, 
'5' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK)  ON JobOrders.JobOrdersID = Positions.JobOrdersID
WHERE  JobOrderDate >= @DateFrom
and JobOrderDate <= @DateTo AND Positions.Status like '%open%'
AND (JobOrders.Owner1 like @Partner  OR JobOrders.Owner2 like @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID, 
'6' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE  ProjectStatus.StatusActive=1
AND (Projects.Owner1 like @Partner OR Projects.Owner2 LIKE @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID,
'7' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
JOIN Interview WITH (NOLOCK) ON Projects.ProjectsID=Interview.ProjectsID
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE  ProjectStatus.StatusActive=1
AND (Projects.Owner1 like @Partner OR Projects.Owner2 like @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID, 
'8' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
WHERE  DateSearchCompleted >= @DateFrom
and DateSearchCompleted <= @DateTo AND ProjectStatus='COMP'
AND (Projects.Owner1 like @Partner OR Projects.Owner2 like @Partner)
UNION
SELECT DISTINCT Projects.ProjectsID,
'9' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
WHERE  ProjectStatus='HOLD'
AND (Projects.Owner1 like @Partner OR Projects.Owner2 like @Partner)
UNION
SELECT DISTINCT Positions.PositionsID,
'10' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON JobOrders.JobOrdersID=Positions.JobOrdersID
WHERE  Positions.Status like '%open%'
AND (JobOrders.Owner1 like @Partner OR JobOrders.Owner2 LIKE @Partner )
UNION
SELECT DISTINCT Positions.PositionsID, 
'11' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Interview WITH (NOLOCK) ON JobOrders.JobOrdersID=Interview.JobOrdersID
JOIN Positions  WITH (NOLOCK) ON JobOrders.JobOrdersID = Positions.JobOrdersID
WHERE  Positions.Status like '%open%'
AND (JobOrders.Owner1 like @Partner  OR JobOrders.Owner2 like @Partner )
UNION
SELECT DISTINCT Positions.PositionsID, 
'12' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON Positions.JobOrdersID = JobOrders.JobOrdersID
WHERE  Positions.FilledDate >= @DateFrom
and Positions.FilledDate <= @DateTo
AND (JobOrders.Owner1 like @Partner OR JobOrders.Owner2 like @Partner)
UNION
SELECT DISTINCT Positions.PositionsID, 
'13' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON Positions.JobOrdersID = JobOrders.JobOrdersID
WHERE Positions.Status like '%HOLD%'
AND (JobOrders.Owner1 like @Partner OR JobOrders.Owner2 like @Partner)
ORDER BY 1,2 DESC
END

GO
CREATE procedure [dbo].[FillActReportTableForGroup] @DateFrom datetime,  @DateTo datetime,
				    @Partner varchar(20),@UserID int	
as
BEGIN 
 
delete from ActReport where SessionID=@@spid
INSERT INTO ActReport ([RecordID],[TypeID],[UserID],
           [DateFrom],[DateTo],[TableName])
SELECT MarketingCallReportID AS RecordID,
'1' AS MType,@UserID,@DateFrom,@DateTo,'MarketingCallReport'
FROM MarketingCallReport  WITH (NOLOCK)  
WHERE AppDate >=@DateFrom and AppDate <=@DateTo
AND  Partner1 in ( SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID )
UNION
SELECT DISTINCT Projects.ProjectsID AS RecordID,
'2' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK) 
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE DateSearchInitiated >=@DateFrom
and DateSearchInitiated <=@DateTo AND ProjectStatus.StatusActive = 1
AND ( Owner1 in ( SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID )
 OR Owner2 in ( SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID ) )
UNION
SELECT 
Opportunities.OpportunitiesID AS RecordID,
'3' AS MType,@UserID,@DateFrom,@DateTo,'Opportunities'
FROM Opportunities WITH (NOLOCK)  
LEFT JOIN LinkOpportunitiesToBusinessObjects WITH (NOLOCK)  ON
Opportunities.OpportunitiesID=LinkOpportunitiesToBusinessObjects.OpportunitiesID
WHERE LinkOpportunitiesToBusinessObjects.OpportunitiesID is null AND
( Manager in ( SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID ) )
AND OppDate >=@DateFrom and OppDate <=@DateTo
UNION
SELECT distinct
ActivityHistory.ActivityHistoryID AS RecordID,
'4' AS MType,@UserID,@DateFrom,@DateTo,'ActivityHistory'
FROM ActivityHistory WITH (NOLOCK) 
LEFT JOIN LinkUsersToActivityHistory WITH (NOLOCK)  
ON LinkUsersToActivityHistory.ActivityHistoryID=ActivityHistory.ActivityHistoryID 
WHERE LinkUsersToActivityHistory.LoginName in ( SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID ) 
AND ActivityHistory.Type like 'Marketing Activit%' and CompletedOn >=@DateFrom
and CompletedOn <=@DateTo
UNION
SELECT DISTINCT Positions.PositionsID,
'5' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK)  ON JobOrders.JobOrdersID = Positions.JobOrdersID
WHERE  JobOrderDate >= @DateFrom
and JobOrderDate <= @DateTo AND Positions.Status like '%open%'
AND  (JobOrders.Owner1 IN (SELECT LoginName
FROM LinkUsersToWorkGroups WITH (NOLOCK)  JOIN UserList WITH (NOLOCK)  ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID)
OR  JobOrders.Owner2 IN (SELECT LoginName
FROM LinkUsersToWorkGroups WITH (NOLOCK)  JOIN UserList WITH (NOLOCK)  ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID))
UNION
SELECT DISTINCT Projects.ProjectsID, 
'6' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE  ProjectStatus.StatusActive=1
AND  (Projects.Owner1 IN (SELECT LoginName FROM 
LinkUsersToWorkGroups WITH (NOLOCK)  JOIN UserList WITH (NOLOCK)  ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID )
OR Projects.Owner2 IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK)  
JOIN UserList WITH (NOLOCK)  ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID))
UNION
SELECT DISTINCT Projects.ProjectsID, 
'7' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
JOIN Interview WITH (NOLOCK) ON Projects.ProjectsID=Interview.ProjectsID
WHERE ProjectStatus.StatusActive=1
AND  (Projects.Owner1 IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID)
OR  Projects.Owner1 IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID) )
UNION
SELECT DISTINCT Projects.ProjectsID, 
'8' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
WHERE  DateSearchCompleted >= @DateFrom
and DateSearchCompleted <= @DateTo AND ProjectStatus='COMP'
AND  (Projects.Owner1 IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK)
JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID) OR
Projects.Owner2 IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID) )
UNION
SELECT DISTINCT Projects.ProjectsID, 
'9' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
WHERE  ProjectStatus='HOLD'
AND  (Projects.Owner1 IN (SELECT LoginName 
FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID ) OR
Projects.Owner2 IN (SELECT LoginName 
FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID))
UNION
SELECT DISTINCT Positions.PositionsID, 
'10' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON JobOrders.JobOrdersID=Positions.JobOrdersID
WHERE  Positions.Status like '%open%'
AND  (JobOrders.Owner1 IN (SELECT LoginName FROM
LinkUsersToWorkGroups WITH (NOLOCK)  JOIN UserList WITH (NOLOCK)  ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID)
OR JobOrders.Owner2 IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK)
JOIN UserList WITH (NOLOCK)  ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID))
UNION
SELECT DISTINCT Positions.PositionsID, 
'11' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Interview WITH (NOLOCK) ON JobOrders.JobOrdersID=Interview.JobOrdersID
JOIN Positions  WITH (NOLOCK) ON JobOrders.JobOrdersID = Positions.JobOrdersID
WHERE Positions.Status like '%open%'
AND  (JobOrders.Owner1 IN (SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID)
OR  JobOrders.Owner1 IN (SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID) )
UNION
SELECT DISTINCT Positions.PositionsID, 
'12' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON Positions.JobOrdersID = JobOrders.JobOrdersID
WHERE  Positions.FilledDate >= @DateFrom
and Positions.FilledDate <= @DateTo
AND  (JobOrders.Owner1 IN (SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID) OR
JobOrders.Owner2 IN (SELECT LoginName FROM LinkUsersToWorkGroups JOIN UserList ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID  = @UserID) )
UNION
SELECT DISTINCT Positions.PositionsID, 
'13' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON Positions.JobOrdersID = JobOrders.JobOrdersID
WHERE Positions.Status like '%HOLD%'
AND  (JobOrders.Owner1 IN (SELECT LoginName
FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID ) OR
JobOrders.Owner2 IN (SELECT LoginName
FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID = @UserID ))
ORDER BY 1,2 DESC
END
GO
GRANT  EXECUTE   ON [dbo].[FillActReportTable]  TO [DeskFlowUsers]
go
GRANT  EXECUTE   ON [dbo].[FillActReportTableForGroup]  TO [DeskFlowUsers]
GO


