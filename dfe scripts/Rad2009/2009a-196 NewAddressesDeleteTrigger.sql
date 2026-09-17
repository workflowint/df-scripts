/*--------------------------------------------------------------------------------------------------------  
    When a Addresses record is deleted, this deletes all records  
    linked to the deleted record.  
   --------------------------------------------------------------------------------------------------------*/  
ALTER TRIGGER [dbo].[AddressesDelete] ON [dbo].[Addresses]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
DELETE FROM MailingAddresses
WHERE AddressesID IN
(	SELECT AddressesID FROM deleted)

update  Positions set AddressesID = NULL, Location = NULL
where  AddressesID IN
(	SELECT AddressesID FROM deleted)

