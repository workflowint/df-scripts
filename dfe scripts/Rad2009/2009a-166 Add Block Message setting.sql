ALTER TABLE ClientConfig
ADD [CBlockMessage] varchar(MAX) NULL

GO

UPDATE ClientConfig
SET CBlockMessage = 'Do you want to use this candidate?'

GO