ALTER TABLE ClientConfig
	ADD DFESovrenURL nvarchar(max) NULL,
	    DFESovrenKey nvarchar(255) NULL

GO

UPDATE ClientConfig
SET DFESovrenURL = 'https://deskflow-asp3.com/dfe_sovren/',
	DFESovrenKey = 'X1234'
