if ( select count(*) from LinkSearchListsToCandStage where ListName='New Project') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName)
select ISNULL (max(SearchListID),0)+1,'New Project' from LinkSearchListsToCandStage 

if ( select count(*) from LinkSearchListsToCandStage where ListName='Delete Project Placement') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName)
select ISNULL (max(SearchListID),0)+1,'Delete Project Placement' from LinkSearchListsToCandStage 

if ( select count(*) from LinkSearchListsToCandStage where ListName='New Project Invoice') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName)
select ISNULL (max(SearchListID),0)+1,'New Project Invoice' from LinkSearchListsToCandStage 

if ( select count(*) from LinkSearchListsToCandStage where ListName='New JobOrder Invoice') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName)
select ISNULL (max(SearchListID),0)+1,'New JobOrder Invoice' from LinkSearchListsToCandStage 

ALTER TABLE CandidateStages add CreateActHistoryOnComplete bit
