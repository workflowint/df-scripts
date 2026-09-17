/****** Object:  StoredProcedure [dbo].[FillActReportTable]    Script Date: 07/08/2019 12:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[FillActReportTable] @DateFrom datetime,  @DateTo datetime,
				    @Partner nvarchar(20),@UserID int	
as
BEGIN 
 
delete from ActReport where SessionID=@@spid
INSERT INTO ActReport ([RecordID],[TypeID],[UserID],
           [DateFrom],[DateTo],[TableName])
SELECT MarketingCallReportID AS RecordID,
'1' AS MType,@UserID,@DateFrom,@DateTo,'MarketingCallReport'
FROM MarketingCallReport  WITH (NOLOCK)  
WHERE ((AppDate >=@DateFrom and AppDate <=@DateTo) OR
( MarketingCallReport.CreatedOn >= @DateFrom   and MarketingCallReport.CreatedOn <= @DateTo ))
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
LEFT JOIN OpportunityTeams  WITH(NOLOCK) ON  Opportunities.OpportunitiesID = OpportunityTeams.OpportunitiesID
WHERE OppDate >=@DateFrom and OppDate <=@DateTo
and Opportunities.Status in
( select Description from  OpportunityStatuses where Active = 1) and 
( Manager LIKE @Partner OR OpportunityTeams.UserLogin LIKE @Partner)
UNION
SELECT distinct
ActivityHistory.ActivityHistoryID AS RecordID,
'4' AS MType,@UserID,@DateFrom,@DateTo,'ActivityHistory'
FROM ActivityHistory WITH (NOLOCK) 
JOIN	ActivityTypes WITH (NOLOCK) ON (ActivityHistory.Type = ActivityTypes.TypeName and UseInBPL =1)
LEFT JOIN LinkUsersToActivityHistory WITH (NOLOCK)  
ON LinkUsersToActivityHistory.ActivityHistoryID=ActivityHistory.ActivityHistoryID 
LEFT JOIN UserList WITH (NOLOCK) ON (LinkUsersToActivityHistory.LoginName = UserList.LoginName )
WHERE 
(ActivityHistory.CompletedBy LIKE @Partner or ActivityHistory.CreatedBy LIKE @Partner
OR UserList.LoginName LIKE @Partner) and
CompletedOn >=@DateFrom and CompletedOn <=@DateTo
UNION
SELECT DISTINCT Positions.PositionsID AS RecordID, 
'5' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK)  ON JobOrders.JobOrdersID = Positions.JobOrdersID
WHERE  JobOrderDate >= @DateFrom
and JobOrderDate <= @DateTo AND Positions.Status like '%open%'
AND (JobOrders.Owner1 like @Partner  OR JobOrders.Owner2 like @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID AS RecordID, 
'6' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE  ProjectStatus.StatusActive=1
AND (Projects.Owner1 like @Partner OR Projects.Owner2 LIKE @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID  AS RecordID,
'7' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
JOIN Interview WITH (NOLOCK) ON Projects.ProjectsID=Interview.ProjectsID
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE  ProjectStatus.StatusActive=1
AND (Projects.Owner1 like @Partner OR Projects.Owner2 like @Partner )
UNION
SELECT DISTINCT Projects.ProjectsID  AS RecordID, 
'8' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
WHERE  DateSearchCompleted >= @DateFrom
and DateSearchCompleted <= @DateTo AND ProjectStatus='COMP'
AND (Projects.Owner1 like @Partner OR Projects.Owner2 like @Partner)
UNION
SELECT DISTINCT Projects.ProjectsID  AS RecordID,
'9' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK)  
WHERE  ProjectStatus='HOLD'
AND (Projects.Owner1 like @Partner OR Projects.Owner2 like @Partner)
UNION
SELECT DISTINCT Positions.PositionsID  AS RecordID,
'10' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON JobOrders.JobOrdersID=Positions.JobOrdersID
WHERE  Positions.Status like '%open%'
AND (JobOrders.Owner1 like @Partner OR JobOrders.Owner2 LIKE @Partner )
UNION
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
'11' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Interview WITH (NOLOCK) ON JobOrders.JobOrdersID=Interview.JobOrdersID
JOIN Positions  WITH (NOLOCK) ON JobOrders.JobOrdersID = Positions.JobOrdersID
WHERE  Positions.Status like '%open%'
AND (JobOrders.Owner1 like @Partner  OR JobOrders.Owner2 like @Partner )
UNION
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
'12' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON Positions.JobOrdersID = JobOrders.JobOrdersID
WHERE  Positions.FilledDate >= @DateFrom
and Positions.FilledDate <= @DateTo
AND (JobOrders.Owner1 like @Partner OR JobOrders.Owner2 like @Partner)
UNION
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
'13' AS MType,@UserID,@DateFrom,@DateTo,'Positions'
FROM JobOrders  WITH (NOLOCK)  
JOIN Positions WITH (NOLOCK) ON Positions.JobOrdersID = JobOrders.JobOrdersID
WHERE Positions.Status like '%HOLD%'
AND (JobOrders.Owner1 like @Partner OR JobOrders.Owner2 like @Partner)
ORDER BY RecordID,MType DESC
END

/****** Object:  StoredProcedure [dbo].[FillActReportTableForGroup]    Script Date: 07/08/2019 12:54:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[FillActReportTableForGroup] @DateFrom datetime,  @DateTo datetime,
				    @Partner nvarchar(20),@UserID int	
as
BEGIN 
 
delete from ActReport where SessionID=@@spid
INSERT INTO ActReport ([RecordID],[TypeID],[UserID],
           [DateFrom],[DateTo],[TableName])
SELECT MarketingCallReportID AS RecordID,
'1' AS MType,@UserID,@DateFrom,@DateTo,'MarketingCallReport'
FROM MarketingCallReport  WITH (NOLOCK)  
WHERE ((AppDate >=@DateFrom and AppDate <=@DateTo) OR
( MarketingCallReport.CreatedOn >= @DateFrom   and MarketingCallReport.CreatedOn <= @DateTo ))
AND  Partner1 in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID )
UNION
SELECT DISTINCT Projects.ProjectsID AS RecordID,
'2' AS MType,@UserID,@DateFrom,@DateTo,'Projects'
FROM Projects  WITH (NOLOCK) 
LEFT JOIN ProjectStatus WITH (NOLOCK)  ON Projects.ProjectStatus =ProjectStatus.Name
WHERE DateSearchInitiated >=@DateFrom
and DateSearchInitiated <=@DateTo AND ProjectStatus.StatusActive = 1
AND ( Owner1 in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID )
 OR Owner2 in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID ) )
UNION
SELECT distinct
Opportunities.OpportunitiesID AS RecordID,
'3' AS MType,@UserID,@DateFrom,@DateTo,'Opportunities'
FROM Opportunities WITH (NOLOCK)
LEFT JOIN OpportunityTeams  WITH(NOLOCK) ON  Opportunities.OpportunitiesID = OpportunityTeams.OpportunitiesID
WHERE Opportunities.Status in ( select Description from  OpportunityStatuses WITH (NOLOCK) where Active = 1) and 
( Manager in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID ) OR  
OpportunityTeams.UserLogin IN (SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK)
JOIN UserList WITH (NOLOCK)  ON  LinkUsersToWorkGroups.LeftID=UserList.UserListID
WHERE RightID = @UserID))
AND OppDate >=@DateFrom and OppDate <=@DateTo
UNION
SELECT distinct
ActivityHistory.ActivityHistoryID AS RecordID,
'4' AS MType,@UserID,@DateFrom,@DateTo,'ActivityHistory'
FROM ActivityHistory WITH (NOLOCK)
JOIN	ActivityTypes WITH (NOLOCK) ON (ActivityHistory.Type = ActivityTypes.TypeName and UseInBPL =1) 
LEFT JOIN LinkUsersToActivityHistory WITH (NOLOCK)  
ON LinkUsersToActivityHistory.ActivityHistoryID=ActivityHistory.ActivityHistoryID 
WHERE (LinkUsersToActivityHistory.LoginName in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) 
JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID=@UserID ) 
OR ActivityHistory.CompletedBy in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) 
JOIN UserList WITH (NOLOCK) ON
LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID= @UserID )  
or ActivityHistory.CreatedBy in ( SELECT LoginName FROM LinkUsersToWorkGroups WITH (NOLOCK) 
JOIN UserList WITH (NOLOCK)  ON LinkUsersToWorkGroups.LeftID=UserList.UserListID WHERE RightID= @UserID ))
and CompletedOn >=@DateFrom and CompletedOn <=@DateTo
UNION
SELECT DISTINCT Positions.PositionsID  AS RecordID,
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
SELECT DISTINCT Projects.ProjectsID  AS RecordID, 
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
SELECT DISTINCT Projects.ProjectsID  AS RecordID, 
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
SELECT DISTINCT Projects.ProjectsID  AS RecordID, 
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
SELECT DISTINCT Projects.ProjectsID  AS RecordID, 
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
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
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
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
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
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
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
SELECT DISTINCT Positions.PositionsID  AS RecordID, 
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
ORDER BY RecordID,MType DESC
END

