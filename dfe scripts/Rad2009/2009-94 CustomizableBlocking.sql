ALTER TABLE People add BlockDescription varchar(50)
GO
IF ( select count(*) from LookupTables where Name ='SkillsLevels')=0
INSERT INTO LookupTables (Name,Description,Editable,Visible)
VALUES ('SkillsLevels','Skills Levels','Name','Name')
GO
ALTER TABLE WorkLists add CanBeBlocked bit, BlockLevel int default(0),ListLevel int 
GO
UPDATE Worklists set CanBeBlocked = 1
UPDATE Worklists set CanBeBlocked = 0 where ListName in ('Placed','Sources','Ad Respondents','Benchmark') 
GO

UPDATE Worklists set BlockLevel = 0
UPDATE Worklists set BlockLevel = 1 where ListName in ('Presented') 
UPDATE Worklists set BlockLevel = 2 where ListName in ('Client Interview') 

Update WorkLists set ListLevel = 1 where ListName in ('File Search','Benchmark','Target Companies','Ad Respondents',
'Internal Search','Sources','Referrals')
Update WorkLists set ListLevel = 2 where ListName ='Contact Register'
Update WorkLists set ListLevel = 3 where ListName ='Internal Interview'
Update WorkLists set ListLevel = 4 where ListName ='Presented'
Update WorkLists set ListLevel = 5 where ListName ='Client Interview'
Update WorkLists set ListLevel = 6 where ListName ='Placed'


