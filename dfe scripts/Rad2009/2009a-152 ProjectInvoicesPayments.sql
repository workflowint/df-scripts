ALTER TABLE ProjectInvoices add InvoiceStatusID int, QBRefID	varchar(36)
GO
CREATE TABLE [dbo].[InvoiceStatus](
	[InvoiceStatusID] [int] identity(1,1)  NOT NULL,
	[InvoiceStatus] [varchar](50) NULL,
 CONSTRAINT [PK_InvoiceStatus] PRIMARY KEY CLUSTERED 
(
	[InvoiceStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[InvoiceStatus]  TO [DeskFlowUsers]
GO
if ( select count(*) from LastIDs where FieldName='InvoicePaidItemsID') =0
INSERT INTO LastIDs ( FieldName,LastID ) VALUES ('InvoicePaidItemsID',1)
GO
ALTER TABLE GroupPermissions add EditLockedInvoiceStatus bit 
GO
CREATE TABLE [dbo].[InvoicePaidItems](
	[InvoicePaidItemsID] [int] NOT NULL,
	[CreatedBy] [varchar](20) NULL CONSTRAINT [DF_InvoicePaidItems_CreatedOn]  DEFAULT (suser_sname()),
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_InvoicePaidItems_CreatedOn_1]  DEFAULT (getdate()),
	[UpdatedBy] [varchar](20) NULL CONSTRAINT [DF_InvoicePaidItems_UpdatedBy]  DEFAULT (suser_sname()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_InvoicePaidItems_UpdatedOn]  DEFAULT (getdate()),
	[ProjectInvoicesID] [int] NULL,
	[PaidDate] [datetime] NULL,
	[PaidDescription] [varchar](50) NULL,
	[PaidAmount] [money] NULL,
	[CurrencyType] [char](3) NULL,
	[ExchangeRate] [float] NULL,
	[ExchangeRateDate] [datetime] NULL,
 CONSTRAINT [PK_InvoicePaidItems] PRIMARY KEY CLUSTERED 
(
	[InvoicePaidItemsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[InvoicePaidItems]  TO [DeskFlowUsers]
GO
CREATE  TRIGGER [dbo].[InvoicePaidItemsUpdate] ON [dbo].[InvoicePaidItems]
FOR UPDATE 
NOT FOR REPLICATION
AS
UPDATE InvoicePaidItems
SET InvoicePaidItems.UpdatedBy = suser_sname(),
InvoicePaidItems.UpdatedOn = GETDATE()
FROM Inserted, InvoicePaidItems 
WHERE Inserted.InvoicePaidItemsID = InvoicePaidItems.InvoicePaidItemsID