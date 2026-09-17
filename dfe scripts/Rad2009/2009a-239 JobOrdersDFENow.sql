ALTER TABLE JobOrders Add PlacedByPeopleDFENow bit, InvoiceToPeopleDFENow bit,ReportsToPeopleDFENow bit
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[StickyInsert]'))
DROP TRIGGER [dbo].[StickyInsert]
GO 
ALTER TABLE LinkUsersToStickies add UTCLastVisited smallint
GO
ALTER  TRIGGER [dbo].[StickyUpdate] ON [dbo].[Sticky] 
FOR  UPDATE 
AS
begin
UPDATE Sticky
SET Sticky.UpdatedBy =suser_sname(),
UpdatedOn = getutcdate(), UTCUpdatedOn=1 
FROM Inserted, Sticky 
WHERE Inserted.StickyID = Sticky.StickyID

UPDATE LinkUsersToStickies 
SET LastModified = getutcdate(), UTCUpdatedOn=1 
FROM Inserted, LinkUsersToStickies
WHERE LinkUsersToStickies.RootStickyID = Inserted.SendStickyID
end

