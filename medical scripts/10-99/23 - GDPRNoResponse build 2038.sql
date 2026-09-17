ALTER TABLE People add GDPRSentDate datetime
go
ALTER TABLE EMailArchive add GDPREmail bit
GO
ALTER TABLE ClientConfig add GDPRNoResponseDays int
go
update ClientConfig set GDPRNoResponseDays = 0 where GDPRNoResponseDays is null
