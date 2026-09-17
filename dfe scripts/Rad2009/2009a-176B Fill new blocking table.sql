-- Script to populate ProjectsCandidateBlocks with initial values
DELETE FROM ProjectsCandidateBlocks


INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 1, MAX(A.CreatedOn)
FROM ProjectsFileSearchCandidates AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 1 )
GROUP BY A.ProjectsID, A.PeopleID
		
GO
		

INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 3, MAX(A.CreatedOn)
FROM ProjectTargetCompaniesCandidates AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 3 )
GROUP BY A.ProjectsID, A.PeopleID


GO		

INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 5, MAX(A.CreatedOn)
FROM ProjectsClientEmployeesLists AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 5 )
GROUP BY A.ProjectsID, A.PeopleID
	
GO
	
INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 7, MAX(A.CreatedOn)
FROM CandidateReferrals AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 7 )
GROUP BY A.ProjectsID, A.PeopleID

GO

INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 8, MAX(A.CreatedOn)
FROM ProjectsTargetLists AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 8 )
GROUP BY A.ProjectsID, A.PeopleID
		
GO

INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 9, MAX(A.CreatedOn)
FROM ProjectsInternalInterviewLists AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 9 )
GROUP BY A.ProjectsID, A.PeopleID

GO

INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 10, MAX(A.CreatedOn)
FROM ProjectsPresentedLists AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 10 )
GROUP BY A.ProjectsID, A.PeopleID

GO

INSERT INTO ProjectsCandidateBlocks
( ProjectsID, PeopleID, WorkListsID, CreatedOn )
SELECT A.ProjectsID, A.PeopleID, 11, MAX(A.CreatedOn)
FROM ProjectsShortLists AS A, Projects, ProjectStatus
WHERE Projects.ProjectsID=A.ProjectsID
        and Projects.ProjectStatus=ProjectStatus.Name and  StatusActive=1
        and IsNull(Projects.NEDProject,0) = 0
AND NOT EXISTS( SELECT B.ProjectsID, B.PeopleID FROM ProjectsCandidateBlocks AS B WITH(UPDLOCK, HOLDLOCK) 
	WHERE A.ProjectsID = B.ProjectsID AND A.PeopleID = B.PeopleID AND B.WorkListsID = 11 )	
GROUP BY A.ProjectsID, A.PeopleID
		
GO

