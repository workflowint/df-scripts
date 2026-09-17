IF EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'CanReceiveBulkEmail' AND [object_id] = OBJECT_ID(N'People'))
BEGIN
	EXEC sp_rename 'People.CanReceiveBulkEmail', 'NoBulkEmail', 'COLUMN'
END
ELSE IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'NoBulkEmail' AND [object_id] = OBJECT_ID(N'People'))
BEGIN

	ALTER TABLE People 
	ADD NoBulkEmail BIT NOT NULL 
	CONSTRAINT DF_People_CanReceiveBulk DEFAULT(0)

END

IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'NoBulkEmailDate' AND [object_id] = OBJECT_ID(N'People'))
BEGIN
	ALTER TABLE People
	ADD NoBulkEmailDate datetime NULL
END
