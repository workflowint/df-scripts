ALTER TRIGGER [dbo].[InterviewOnDelete] ON [dbo].[Interview]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
DELETE FROM LinkInterviewersToClientInterview WHERE RightID IN(SELECT InterviewID FROM deleted)
DELETE FROM Task WHERE TaskID IN(SELECT TaskID FROM deleted) AND CallCode IS NULL
DELETE FROM LinkClnInterviewsToResults WHERE InterviewsID IN (SELECT InterviewID FROM deleted)

