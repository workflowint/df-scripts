ALTER TABLE ProjectStatus add FontColor int, Color int
go
ALTER TABLE ClientConfig add CompaniesBannerLine varchar(255),ProjectsBannerLine varchar(255)
GO
UPDATE DataCashTables set UpdatedOn = getdate() where Name='ProjectStatus'