if ((select count(*) from DataCashTables  where Name='Gender')=0 )
insert into DataCashTables (Name ) Values ('Gender')
GO
ALTER TABLE People ALTER Column Gender nvarchar(10)
GO
ALTER TABLE People add Pronoun nvarchar(50)
GO
CREATE TABLE [dbo].[Pronouns](
	[PronounID] [int] IDENTITY(1,1) NOT NULL,
	[Pronoun] [nvarchar](50) NULL,
 CONSTRAINT [PK_Pronoun] PRIMARY KEY CLUSTERED 
(
	[PronounID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Pronouns]  TO [DeskFlowUsers]
GO
IF NOT EXISTS( SELECT 1 FROM LookupTables WHERE Name = 'Pronouns' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('Pronouns', 'Person Pronouns', 'Pronoun', 'Pronoun' )
END
GO
if ((select count(*) from DataCashTables  where Name='Pronouns')=0 )
insert into DataCashTables (Name ) Values ('Pronouns')