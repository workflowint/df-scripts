ALTER TABLE ClientConfig add APIAccountID varchar(100), APIAdminUserName varchar(100),
DocuSignConsentLink varchar(max), DocuSignBaseUri varchar(255)
go
ALTER TABLE UserList add UserDocuSignID varchar(100), DocuSignConsent bit