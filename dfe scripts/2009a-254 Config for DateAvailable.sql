ALTER TABLE ClientConfig
ADD SetCandidateDateAvailable bit null
GO
UPDATE ClientConfig
SET SetCandidateDateAvailable= 0 -- 0 for false 1 for true (default)