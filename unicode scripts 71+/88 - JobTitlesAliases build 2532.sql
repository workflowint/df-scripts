CREATE TABLE [dbo].[TitlesAliases](
	[TitlesAliasesID] [int] IDENTITY(1,1) NOT NULL,
	[TitlesID] [int] NULL,
	[TitlesAliasesName] [nvarchar](255) NULL,
 CONSTRAINT [PK_TitlesAliases] PRIMARY KEY CLUSTERED 
(
	[TitlesAliasesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[TitlesAliases]  TO [DeskFlowUsers]

