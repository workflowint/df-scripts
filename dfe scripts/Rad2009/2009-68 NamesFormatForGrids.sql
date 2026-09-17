ALTER TABLE ClientConfig add NamesFormat int
GO
UPDATE  ClientConfig set NamesFormat=0 where NamesFormat is null
