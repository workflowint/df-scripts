ALTER TABLE UserEMailSettings add AddClientLink bit
go
update UserEMailSettings set AddClientLink =1 where AddClientLink is null