ALTER TABLE worklists add CopyToLists varchar(255)
GO
update worklists set CopyToLists ='Contact Register,Internal Interview,Presented' where ListLevel=1 and ListName<>'Sources'
update worklists set CopyToLists ='Internal Interview,Presented' where ListLevel=2 
update worklists set CopyToLists ='Presented,Client Interview' where ListLevel=3 
update worklists set CopyToLists ='Client Interview' where ListLevel=4 
GO
ALTER TABLE OpportunityStatuses add Active bit 
GO
UPDATE OpportunityStatuses set Active = 1
GO
ALTER TABLE CallSheets add Comments varchar(255)
GO
if ( select count(*) from LookupTables where name='TypesOfMarketingCalls')=0
INSERT INTO LookupTables(Name,description,Editable,Visible,Candelete)
VALUES ('TypesOfMarketingCalls','MCR call purpose','Description','Description',1)
GO
ALTER TABLE People ALTER COLUMN WebPassword varchar(50)