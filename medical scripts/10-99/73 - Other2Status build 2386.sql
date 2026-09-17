ALTER TABLE People add Status3 varchar(50)
GO
CREATE TABLE [dbo].[PeopleStatus3](
	[PeopleStatus3ID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](50) NULL,
	[FontColor] [int] NULL,
 CONSTRAINT [PK_[PeopleStatus3ID] PRIMARY KEY CLUSTERED 
(
	[PeopleStatus3ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PeopleStatus3]  TO [DeskFlowUsers]
GO
IF NOT EXISTS( SELECT 1 FROM LookupTables WHERE Name = 'PeopleStatus3' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('PeopleStatus3', 'Other 2 People Status', 'StatusName', 'StatusName' )
END