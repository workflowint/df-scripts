IF (select count(*) from LookupTables where name = 'Ranks' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('Ranks','Candidate Ranks 1 and 2','Description','Description')
GO

CREATE TABLE [dbo].[Ranks](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ranks] WITH NOCHECK ADD 
 CONSTRAINT [PK_Ranks] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Ranks]  TO [DeskFlowUsers]
GO

IF ( SELECT COUNT(*) FROM DataCashTables WHERE Name='Ranks' )=0
INSERT INTO DataCashTables ( Name,UpdatedOn) VALUES('Ranks',getdate())

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RanksTrigger]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[RanksTrigger]
GO
CREATE TRIGGER RanksTrigger ON [dbo].[Ranks] 
FOR INSERT, UPDATE, DELETE 
AS

UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='Ranks'
GO