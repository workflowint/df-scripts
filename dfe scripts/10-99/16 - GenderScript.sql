CREATE TABLE [dbo].[Gender](
	[GenderID] [int] IDENTITY(1,1) NOT NULL,
	[GenderDescription] [varchar](10) NULL,
 CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED 
(
	[GenderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Gender]  TO [DeskFlowUsers]

GO
If not exists ( select GenderID from Gender where GenderDescription='F')
insert into Gender (GenderDescription) values ( 'F')
GO
If not exists ( select GenderID from Gender where GenderDescription='M')
insert into Gender (GenderDescription) values ( 'M')
GO
IF NOT EXISTS( SELECT 1 FROM LookupTables WHERE Name = 'Gender' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('Gender', 'Person Gender', 'GenderDescription', 'GenderDescription' )
END
