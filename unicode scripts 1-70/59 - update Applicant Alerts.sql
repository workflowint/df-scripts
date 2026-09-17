ALTER TABLE [dbo].[ApplicantAlerts] ADD  CONSTRAINT [DF_ApplicantAlerts_RetryCount]  DEFAULT ((0)) FOR [RetryCount]
GO

UPDATE ApplicantAlerts SET RetryCount = 0 WHERE RetryCount IS NULL
GO
