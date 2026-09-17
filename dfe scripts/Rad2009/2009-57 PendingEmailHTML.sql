ALTER TABLE EMailArchive add MsgBodyHTML text,CCs varchar(255),Format int
GO
ALTER TABLE ProjectsTeam add Correspondence bit
GO
UPDATE ProjectsTeam set Correspondence = 1 
GO
ALTER TABLE UserList add CustomStamp varchar(255)

