ALTER TABLE ClientConfig add UsePrivateEmailForm bit
GO
ALTER TABLE EMailArchive add MsgType varchar(50), SendingUser varchar(50)
GO
ALTER TABLE EMailMsgRecipients add RUserLogin varchar(20),  RPeopleID int
go
ALTER TABLE EMailMsgAttachments add BFilePath varchar(255),DateCreated datetime, FileExt varchar(10)
GO
Create Index EMailMsgRecipients_RUserLogin ON  dbo.EMailMsgRecipients(RUserLogin) 
GO
Create Index EMailMsgRecipients_RPeopleID ON  dbo.EMailMsgRecipients(RPeopleID) 

