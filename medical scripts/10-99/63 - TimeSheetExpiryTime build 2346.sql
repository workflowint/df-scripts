CREATE TABLE TimeSheetsLogins (
	TimeSheetsLoginsID	int IDENTITY(1,1) PRIMARY KEY,
	CreatedOn datetime DEFAULT GETUTCDATE(),
	CreatedBy varchar(20) default suser_sname(),
	PeopleID int,
	LoginName varchar(100) NOT NULL UNIQUE,	
	PasswordHash varchar(255),	
	PermissionLevel	int,
	SessionID varchar(255),
	WebToken varchar(255),
	WebTokenExpires	datetime
)
go
CREATE TABLE TimeSheetsCodes (
	TimeSheetsCodesID int IDENTITY(1,1) PRIMARY KEY,
	CreatedOn datetime DEFAULT GETUTCDATE(),
	PeopleID int NOT NULL,
	Code varchar(255) NOT NULL UNIQUE,
	CodeType int NOT NULL,
	CodeExpiry datetime NOT NULL
)
go
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[TimeSheetsLogins] TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[TimeSheetsCodes] TO [DeskFlowUsers]
GO
ALTER TABLE JobOrderSchedule add UserStatus int
GO
ALTER TABLE ClientConfig add TimeSheetsExpiryTime int
GO
ALTER TABLE TimeSheets add JobOrderScheduleID int
GO