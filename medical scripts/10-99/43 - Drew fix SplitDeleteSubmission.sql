  
alter TRIGGER SplitDeleteSubmission ON dbo.JobOrderInterviewPeople  
FOR DELETE  
AS  
  
delete UsersCommissionsSplit  
from deleted,UsersCommissionsSplit  
where deleted.PeopleID = UsersCommissionsSplit.PeopleID and   
deleted.JobOrdersID = UsersCommissionsSplit.JobOrdersID and UsersCommissionsSplit.ObjectID=0 and  
Type='Submission'  
  