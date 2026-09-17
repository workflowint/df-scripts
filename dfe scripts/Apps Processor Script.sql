ALTER TABLE ClientConfig
ADD LogProcessorEmails BIT NOT NULL DEFAULT 0
GO

UPDATE ClientConfig
SET LogProcessorEmails = 1
