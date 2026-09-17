ALTER TABLE ClientConfig add APIAccountID nvarchar(100), APIAdminUserName nvarchar(100),
DocuSignConsentLink nvarchar(max), DocuSignBaseUri nvarchar(255)
go
ALTER TABLE UserList add UserDocuSignID nvarchar(100), DocuSignConsent bit