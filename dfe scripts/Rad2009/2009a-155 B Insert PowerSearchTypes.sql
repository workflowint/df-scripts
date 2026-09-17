declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'People' AND ParentType IS NULL )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'People', NULL, 'Find People', NULL, NULL, 'People', 'PeopleID' )
	
END

GO

declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Company' AND ParentType IS NULL )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Company', NULL, 'Find Companies', NULL, NULL, 'Companies', 'CompaniesID')
	
END

GO

declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Project' AND ParentType IS NULL )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Project', NULL, 'Find Project', NULL, NULL, 'Projects', 'ProjectsID' )
	
END

GO

declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'JobOrder' AND ParentType IS NULL )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'JobOrder', NULL, 'Find Job Orders', NULL, NULL, 'JobOrders', 'JobOrdersID' )
	
END

GO

declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Position' AND ParentType = 'People' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Position', 'People', 'Find Positions for People', ' - Positions for People',
		'SELECT PeopleID FROM Positions WITH(NOLOCK) WHERE', 'Positions', 'PositionsID' )
	
END

GO

declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'People' AND ParentType = 'People' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'People', 'People', 'Find People', 'People',
		'SELECT PeopleID FROM People WITH(NOLOCK) WHERE', 'People', 'PeopleID' )
	
END

GO

declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Address' AND ParentType = 'People' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Address', 'People', 'Find Home Address for People', '- Home Address for People',
		'SELECT PeopleID FROM People WITH(NOLOCK) LEFT JOIN Addresses ON 
		(People.HomeAddressesID = Addresses.AddressesID) WHERE', 'Addresses', 'AddressesID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Education' AND ParentType = 'People' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Education', 'People', 'Find Education for People', '- Education for People',
		'SELECT PeopleID FROM People WITH(NOLOCK) WHERE', 'Education', 'EducationID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Address' AND SearchID = 'AddressesID' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Address', 'People', 'Find Business Address for People', '- Bus. Address for People',
		'SELECT People.PeopleID FROM People WITH(NOLOCK) LEFT JOIN Positions CurrPos ON
		(People.PeopleID = CurrPos.PeopleID AND ISNULL(CurrPos.EndDate,(GETDATE() + 1)) > GETDATE()) 
		LEFT JOIN Addresses ON (Addresses.AddressesID = CurrPos.AddressesID) WHERE', 'Addresses', 'AddressesID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Opportunity' AND ParentType IS NULL )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Opportunity', NULL, 'Find Opportunities', NULL, NULL, 'Opportunities', 'OpportunitiesID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'JobRequirements' AND ParentType = 'Opportunity' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'JobRequirements', 'Opportunity', 'Find Requirements for Opportunities', '- Requirements for Opportunity',
		'SELECT OpportunitiesID FROM JobRequirements WITH(NOLOCK) WHERE', 'JobRequirements', 'JobRequirementsID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Company' AND ParentType = 'Company' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Company', 'Company', 'Find Companies', 'Company',
		'SELECT CompaniesID FROM Companies WITH(NOLOCK) WHERE', 'Companies', 'CompaniesID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'Project' AND ParentType = 'Project' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'Project', 'Project', 'Find Projects', 'Project',
		'SELECT ProjectsID FROM Projects WITH(NOLOCK) WHERE', 'Projects', 'ProjectsID' )
	
END

GO
declare @linkid int
IF NOT EXISTS( SELECT * FROM PowerSearchTypes WHERE [Type] = 'JobOrder' AND ParentType = 'JobOrder' )
BEGIN
	exec GetNewID @Name='PowerSearchTypesID',@LastID=@linkid output;

	insert into PowerSearchTypes
		(PowerSearchTypesID, Type, ParentType, Description, MenuDescription, LinkSQL, SearchTable, SearchID)
	values
		(@linkid, 'JobOrder', 'JobOrder', 'Find Job Orders', 'Job Order',
		'SELECT JobOrdersID FROM JobOrders WITH(NOLOCK) WHERE', 'JobOrders', 'JobOrdersID' )
	
END

GO
select * from PowerSearchTypes 


