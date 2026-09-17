IF EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'CanReceiveBulkEmail' AND [object_id] = OBJECT_ID(N'People'))
BEGIN
	EXEC sp_rename 'People.CanReceiveBulkEmail', 'NoBulkEmail', 'COLUMN'
END
ELSE
BEGIN

	ALTER TABLE People 
	ADD NoBulkEmail BIT NOT NULL 
	CONSTRAINT DF_People_CanReceiveBulk DEFAULT(0)

END
