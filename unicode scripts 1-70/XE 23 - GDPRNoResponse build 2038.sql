ALTER TABLE People add GDPRSentDate datetime
go
ALTER TABLE EMailArchive add GDPREmail bit
GO
ALTER TABLE ClientConfig add GDPRNoResponseDays int
go
update ClientConfig set GDPRNoResponseDays = 0 where GDPRNoResponseDays is null
GO
ALTER TABLE WebLogins
ADD Photo varbinary(MAX) NULL,
	Gender nvarchar(1) NULL,
	Birthday datetime NULL
	
GO

ALTER TABLE WebApplications
ADD Photo varbinary(MAX) NULL

GO

ALTER TABLE Duplicates
ADD Photo varbinary(MAX) NULL

GO
