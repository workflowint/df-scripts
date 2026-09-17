if ( select count(*) from LookupTables where name='TypesOfMarketingCalls')=0
INSERT INTO LookupTables(Name,description,Editable,Visible,Candelete)
VALUES ('TypesOfMarketingCalls','Types Of Marketing Calls','Description','Description',1)
GO
if ( select count(*) from LookupTables where name='ProjectInvoiceTypes')=0
INSERT INTO LookupTables(Name,description,Editable,Visible,Candelete)
VALUES ('ProjectInvoiceTypes','Project Invoice Types','Description','Description',1)
