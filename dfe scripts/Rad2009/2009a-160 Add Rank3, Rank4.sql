ALTER TABLE ProjectsCallStatus
ADD [PCRank] varchar(100) NULL,
	[PCRank2] varchar(100) NULL
	
GO

ALTER TABLE MProjectCompaniesContacts
ADD [Rank3] varchar(10) NULL

GO

ALTER TABLE MProjectCompaniesLists
ADD [Rank3] varchar(100) NULL

GO
IF ( SELECT count(*) FROM LookupTables WHERE Name = 'AccExpCustomLookup1' ) = 0
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('AccExpCustomLookup1', 'AccExpCustomLookup1 for Account Experience', 'Description', 'Description' )
GO
IF ( SELECT count(*) FROM LookupTables WHERE Name = 'AccExpCustomLookup2' ) = 0
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('AccExpCustomLookup2', 'AccExpCustomLookup2 for Account Experience', 'Description', 'Description' )
