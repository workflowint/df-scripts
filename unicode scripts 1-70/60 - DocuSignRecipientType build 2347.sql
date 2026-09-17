ALTER TABLE DocuSignSignees add RecipientType nvarchar ( 50 )
GO
CREATE TABLE [dbo].[DocuSignRecipientTypes](
	[DocuSignRecipientTypesID] [int] IDENTITY(1,1) PRIMARY KEY,
	[RecipientType] [nvarchar](50) NULL,
	Active            [bit]
	)
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DocuSignRecipientTypes] TO [DeskFlowUsers]
GO
if (( select count(*) from DocuSignRecipientTypes ) = 0 )
begin
INSERT INTO DocuSignRecipientTypes ( RecipientType ) values ('Carbon Copy')
INSERT INTO DocuSignRecipientTypes ( RecipientType ) values ('Editor')
end