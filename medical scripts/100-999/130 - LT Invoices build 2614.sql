ALTER TRIGGER [dbo].[ContractInvoicesDelete] ON [dbo].[ContractInvoices]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
DELETE FROM ContractInvoiceItems WHERE ContractInvoicesID IN(SELECT ContractInvoicesID FROM deleted)

GO

ALTER TRIGGER [dbo].[ContractInvoiceItemsDelete] ON [dbo].[ContractInvoiceItems]  
FOR DELETE  
AS
-----------------------------------------------------------------------------------------------------------  
UPDATE TimeSheets SET DateProcessed = NULL, ContractInvoiceItemsID = NULL
WHERE ContractInvoiceItemsID IN(SELECT ContractInvoiceItemsID FROM deleted)

UPDATE AssignmentExpenses SET DateProcessed = NULL, ContractInvoiceItemsID = NULL
WHERE ContractInvoiceItemsID IN(SELECT ContractInvoiceItemsID FROM deleted)

UPDATE PositionExpenses SET DateProcessed = NULL, ContractInvoiceItemsID = NULL
WHERE ContractInvoiceItemsID IN(SELECT ContractInvoiceItemsID FROM deleted)
