ALTER TABLE ClientConfig add SourceForCandidate bit, SourceForContact bit
GO
UPDATE ClientConfig set SourceForCandidate = 1