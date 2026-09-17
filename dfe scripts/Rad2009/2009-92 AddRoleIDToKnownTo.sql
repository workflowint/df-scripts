ALTER TABLE LinkPeopleToKnownToUsers add UserRoleID int
GO
UPDATE Lookuptables set Visible='Name,Description' where name='TypesOfMarketingCalls'
GO
CREATE TABLE [dbo].[KnownToRoles](
	[KnownToRolesID] [int] IDENTITY(1,1) NOT NULL,
	[KnownToRole] [varchar](50) NULL,
	CONSTRAINT [PK_KnownToRoles] PRIMARY KEY CLUSTERED 
	(
		[KnownToRolesID] ASC
	)
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[KnownToRoles]  TO [DeskFlowUsers]
GO
if ( select count(*) from LookupTables where name='KnownToRoles')=0
INSERT INTO LookupTables(Name,description,Editable,Visible,Candelete)
VALUES ('KnownToRoles','Known To Roles','KnownToRole','KnownToRole',1)
