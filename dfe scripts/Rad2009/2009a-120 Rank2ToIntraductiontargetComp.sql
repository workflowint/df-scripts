ALTER TABLE MProjectCompaniesLists add Rank2 varchar(100)
GO
ALTER TABLE MProjectCompaniesLists ALTER COLUMN Rank varchar(100)
GO
CREATE TABLE [dbo].[TargetCompanyRanks](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
	[Color] [int] NULL,
	[FontColor] [int] NULL,
 CONSTRAINT [PK_TargetCompanyRanks] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF (select count(*) from LookupTables where name = 'TargetCompanyRanks' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('TargetCompanyRanks','Target Company Ranks 1 and 2','Description','Description')
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[TargetCompanyRanks]  TO [DeskFlowUsers]
