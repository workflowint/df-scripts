ALTER TABLE EmailArchive
ALTER COLUMN AuthorAddress  varchar(max)
GO
ALTER TABLE EmailArchive
ALTER COLUMN AuthorDisplayName varchar(255)
GO
ALTER TABLE EmailMsgRecipients
ALTER COLUMN Address varchar(max)
GO