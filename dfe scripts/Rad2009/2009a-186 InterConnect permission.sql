IF NOT EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'AllowInterConnect' AND Object_ID = Object_ID(N'ClientConfig'))
BEGIN
	ALTER TABLE ClientConfig
	ADD [AllowInterConnect] [bit] NULL DEFAULT (0)
END

GO

UPDATE ClientConfig SET AllowInterConnect = 1

GO