ALTER TABLE EMailArchive add AHType varchar(255)
GO
IF (select count(*) from ActivityTypes where TypeName='EMAIL SENT - BULK') = 0
insert into ActivityTypes (TypeName) values ('EMAIL SENT - BULK')