/****** Object:  Trigger [dbo].[CompaniesBlockInsert]    Script Date: 09/14/2016 18:21:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[CompaniesBlockInsert] ON [dbo].[CompaniesBlock]
FOR INSERT
NOT FOR REPLICATION 
AS
BEGIN

	-- UPDATE Company Block Info
	-- Update companies table to inherit any existing blocks
	UPDATE Companies
	SET Block = a.Block,
		BlockUntilDate = a.BlockUntilDate,
		BlockedBy = a.BlockedBy,
		BlockNotes = a.BlockNotes,
		LastProjectID = a.ProjectsID
	FROM
		CompaniesBlock as a
		INNER JOIN Inserted 	
		ON a.CompaniesBlockID = Inserted.CompaniesBlockID
	WHERE Companies.CompaniesID = a.CompaniesID
	AND IsNull(a.Block,0) > 0
	AND IsNull(a.BlockUntilDate,0) > IsNull(Companies.BlockUntilDate,0)

END
