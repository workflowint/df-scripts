ALTER TABLE WebApplications
ADD [EmailOptStatus] [bit] NULL,
	[EmailOptDate] [datetime] NULL,
	[EmailOptDateIsUTC] [bit] NULL
GO	
UPDATE WebApplications
SET EmailOptStatus = CASE WHEN NoBulkEmail = 1 THEN 0 ELSE 1 END,
	EmailOptDate = NoBulkEmailDate,
	EmailOptDateIsUTC = 0
WHERE NoBulkEmailDate IS NOT NULL AND EmailOptDate IS NULL
