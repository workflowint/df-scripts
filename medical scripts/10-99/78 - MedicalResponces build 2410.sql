ALTER TABLE Responces add TimePeriod varchar(10)
GO
ALTER TABLE Responces add WorkGroups varchar(255)
GO
ALTER TABLE LinkSearchListsToCandStage add ForPosition bit
GO
ALTER TABLE Responces add ContactRole1 varchar(50), ContactRole2 varchar(50),ContactRole3 varchar(50)
GO
ALTER TABLE Responces add NewPositionStatus varchar(50)
GO
ALTER TABLE Responces add TaskEventDate int
GO
ALTER TABLE Responces add Warning int
GO
ALTER TABLE Responces add ToSelectedRoles bit, SelectedRoles varchar(255)
GO
if ( select COUNT(*) from Responces)=0
begin
delete from LinkSearchListsToCandStage
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 26,'Considered',1,1 ) 
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 27,'Applicants',1,1 ) 
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders )
values ( 30,'Presented',1,1 ) 
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 31,'Client Interview List',1,1 ) 
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 32,'Client Interview',1,1 ) 
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 33,'Placed',1,1 ) 
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 34,'New JobOrder',0,1 ) 
end
GO
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders)
values ( 35,'DocuSign',0,1 ) 
GO
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList)
values ( 36,'No Search DocuSign',0 ) 
GO
update DataCashTables set UpdatedOn = GETDATE() where Name='Responces'