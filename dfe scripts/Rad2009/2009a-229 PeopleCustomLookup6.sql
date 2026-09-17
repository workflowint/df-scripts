CREATE TABLE [dbo].[People_CustomLookup6](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_People_CustomLookup6] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[People_CustomLookup6]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'People_CustomLookup6' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('People_CustomLookup6', 'CustomLookup6 on PEOPLE extra tab', 'Description', 'Description' )
END

GO

ALTER TABLE People
ADD 
	[CustomLookup6] [varchar](100) NULL
	
GO