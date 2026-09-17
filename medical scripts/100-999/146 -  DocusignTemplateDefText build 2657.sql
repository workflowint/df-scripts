ALTER TABLE [dbo].[PositionExpenses] ADD  CONSTRAINT [DF_JobOrderExpenses_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[PositionExpenses] ADD  CONSTRAINT [DF_JobOrderExpenses_UpdatedBy]  DEFAULT (suser_sname()) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[PositionExpenses] ADD  CONSTRAINT [DF__JobOrderExpenses_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
CREATE   TRIGGER [dbo].[PositionExpensesUpdate] ON [dbo].[PositionExpenses]
FOR UPDATE
AS

update PositionExpenses set 
             PositionExpenses.UpdatedBy = suser_sname(),
             PositionExpenses.UpdatedOn = getutcdate(), UTCUpdatedOn=1 
FROM Inserted, PositionExpenses 
WHERE Inserted.PositionExpensesID = PositionExpenses.PositionExpensesID
GO
EXEC sp_rename 'dbo.PositionExpenses.SalesApprovedOn', 'SubmittedOn', 'COLUMN'
GO
EXEC sp_rename 'dbo.PositionExpenses.SalesApprovedBy', 'SubmittedBy', 'COLUMN'
GO
EXEC sp_rename 'dbo.PositionExpenses.RecApprovedOn', 'ApprovedOn', 'COLUMN'
GO
ALTER TABLE PositionExpenses add ApprovedBy int
GO
ALTER TABLE Templates add TemplateDocuSignText varchar(max), TemplateDocuSignSubject varchar(100)