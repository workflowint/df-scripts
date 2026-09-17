ALTER TABLE LinkSearchListsToCandStage add ForProject bit, ForJobOrders bit
go 
update LinkSearchListsToCandStage set ForProject = 1 where Listname <>'New JobOrder Invoice'
GO
update LinkSearchListsToCandStage set ForJobOrders = 1 where Listname = 'New JobOrder Invoice'
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Target Companies Employees') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Target Companies Employees',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Sources') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Sources',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Recommended') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Recommended',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Considered') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Considered',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Applicants') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Applicants',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Internal Interview List') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Internal Interview List',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Internal Interview') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Internal Interview',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Presented') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Presented',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Client Interview List') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Client Interview List',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Client Interview') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Client Interview',1,1 from LinkSearchListsToCandStage 
GO
if ( select count(*) from LinkSearchListsToCandStage where ForJobOrders=1 and ListName='Placed') =0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName, IsList, ForJobOrders)
select ISNULL (max(SearchListID),0)+1,'Placed',1,1 from LinkSearchListsToCandStage 
