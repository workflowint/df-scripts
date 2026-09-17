ALTER  TRIGGER [dbo].[JobOrdersAudit] ON [dbo].[JobOrders]
FOR INSERT, DELETE, UPDATE 
AS
    IF (SELECT COUNT(*) FROM inserted) > 0 
    BEGIN 
        IF (SELECT COUNT(*) FROM deleted) > 0 
        BEGIN 
            -- update!
			-- Owner1
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'Owner1', 'varchar', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.Owner1, inserted.Owner1 FROM deleted JOIN inserted ON
			( deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.Owner1, '') <> ISNULL(inserted.Owner1, '') ) ) 
			-- Owner2
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'Owner2', 'varchar', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.Owner2, inserted.Owner2 FROM deleted JOIN inserted ON
			( deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.Owner2, '') <> ISNULL(inserted.Owner2, '') ) ) 
			-- CompaniesID
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'CompaniesID', 'int', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.CompaniesID, inserted.CompaniesID FROM deleted JOIN inserted ON
			(deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.CompaniesID, 0) <> ISNULL(inserted.CompaniesID, 0) ) ) 
			-- PlacedByPeopleID
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'PlacedByPeopleID', 'int', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.PlacedByPeopleID, inserted.PlacedByPeopleID 
			FROM deleted JOIN inserted ON
			(deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.PlacedByPeopleID, 0) <> ISNULL(inserted.PlacedByPeopleID, 0) ) ) 
			-- InvoiceToPeopleID
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'InvoiceToPeopleID', 'int', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.InvoiceToPeopleID, inserted.InvoiceToPeopleID 
			FROM deleted JOIN inserted ON
			(deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.InvoiceToPeopleID, 0) <> ISNULL(inserted.InvoiceToPeopleID, 0) ) ) 
			-- ReportsToPeopleID
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'ReportsToPeopleID', 'int', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.ReportsToPeopleID, inserted.ReportsToPeopleID 
			FROM deleted JOIN inserted ON
			(deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.ReportsToPeopleID, 0) <> ISNULL(inserted.ReportsToPeopleID, 0) ) ) 
			-- OrderStatus
			INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
			ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
			SELECT 1, 'JobOrders', 'OrderStatus', 'varchar', 'JobOrdersID', 
			inserted.JobOrdersID, deleted.OrderStatus, inserted.OrderStatus 
			FROM deleted JOIN inserted ON
			(deleted.JobOrdersID = inserted.JobOrdersID 
			AND ( ISNULL(deleted.OrderStatus, '') <> ISNULL(inserted.OrderStatus, '') ) ) 

        END 
        ELSE 
            -- insert! 
		INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
		ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
		SELECT 0, 'JobOrders', 'JobOrdersID', 'int', 'JobOrdersID', 
		inserted.JobOrdersID, NULL, inserted.JobOrdersID FROM inserted
    END 
    ELSE 
    BEGIN 
        -- delete! 
		INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
		ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue,ObjectDescription )
		SELECT 2, 'JobOrders', 'JobOrdersID', 'int', 'JobOrdersID', 
		deleted.JobOrdersID, deleted.JobOrdersID, NULL,deleted.JobTitle FROM deleted
    END 

GO
ALTER  TRIGGER [dbo].[PositionsAudit] ON [dbo].[Positions]
FOR INSERT, DELETE, UPDATE 
AS begin
	set nocount on

    IF (SELECT COUNT(*) FROM inserted) > 0 
    BEGIN 
        IF (SELECT COUNT(*) FROM deleted) > 0 
        BEGIN 
            -- update!
		BEGIN
		INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
		ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
		SELECT 1, 'Positions', 'Status', 'varchar', 'PositionsID', 
		inserted.PositionsID, deleted.Status, inserted.Status FROM deleted JOIN inserted ON
		(deleted.PositionsID = inserted.PositionsID 
		AND inserted.JobOrdersID > 0 AND 
		((deleted.Status IS NULL AND inserted.Status IS NOT NULL) OR (deleted.Status <> inserted.Status)
		OR (deleted.Status IS NOT NULL AND inserted.Status IS NULL)))
		END
		BEGIN
		INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
		ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
		SELECT 1, 'Positions', 'StartDate', 'datetime', 'PositionsID', 
		inserted.PositionsID, CONVERT(varchar(16), deleted.StartDate, 120), 
		CONVERT(varchar(16), inserted.StartDate, 120) FROM deleted JOIN inserted ON
		(deleted.PositionsID = inserted.PositionsID AND inserted.JobOrdersID > 0
		AND ( (inserted.StartDate <> deleted.StartDate ) OR (inserted.StartDate IS NULL AND deleted.StartDate IS NOT NULL)
		OR (inserted.StartDate IS NOT NULL AND deleted.StartDate IS NULL)))
		END
        END 
        ELSE 
        BEGIN 
            -- insert! 
		INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
		ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue )
		SELECT 0, 'Positions', 'PositionsID', 'int', 'PositionsID', 
		inserted.PositionsID, NULL, inserted.PositionsID FROM inserted WHERE inserted.JobOrdersID > 0
        END 
    END 
    ELSE 
    BEGIN 
        -- delete! 
	INSERT INTO MonitorDataChanges ( ChangeType, ChangedTableName, ChangedFieldName,
	ChangedDataType, IDFieldName, IDFieldValue, OldValue, NewValue,ObjectDescription )
	SELECT 2, 'Positions', 'PositionsID', 'int', 'PositionsID', 
	deleted.PositionsID, deleted.PositionsID, NULL,deleted.JobTitle FROM deleted
    END 
end