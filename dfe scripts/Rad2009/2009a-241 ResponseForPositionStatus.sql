ALTER TABLE LinkSearchListsToCandStage add ForPosition bit
GO
ALTER TABLE Responces add ContactRole1 varchar(50), ContactRole2 varchar(50),ContactRole3 varchar(50)
GO
if ( select COUNT(*) from LinkSearchListsToCandStage where ListName='Contract Position Status Change')=0
INSERT INTO LinkSearchListsToCandStage ( SearchListID,ListName,IsList,ForJobOrders, ForPosition)
select MAX(SearchListID)+1,'Contract Position Status Change',0,1,1 from LinkSearchListsToCandStage 
GO
ALTER TABLE Responces add NewPositionStatus varchar(50)
GO
update DataCashTables set UpdatedOn = GETDATE() where Name='Responces'