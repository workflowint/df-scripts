ALTER TABLE ClientConfig
	ADD DFESovrenURL nvarchar(max) NULL,
	    DFESovrenKey nvarchar(255) NULL

GO

UPDATE ClientConfig
SET DFESovrenURL = 'https://deskflow-asp3.com/dfe_sovren/',
	DFESovrenKey = 'WELLF8714'
	GO
ALTER TABLE ActivityTypes add DefaultNotes nvarchar(max)
GO
UPDATE DataCashTables set UpdatedOn= GETDATE() where Name ='ActivityTypes'
GO
ALTER TABLE UserLastTouch add OpenMyDoctors tinyint
