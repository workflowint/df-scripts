ALTER TABLE GlobalEmailSettings add ArchiveForAllOnSend bit
go
update GlobalEmailSettings set ArchiveForAllOnSend = 0
