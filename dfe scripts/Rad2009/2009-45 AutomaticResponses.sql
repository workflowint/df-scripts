ALTER TABLE LinkSearchListsToCandStage add IsList bit
GO
CREATE TABLE Responces
( 
	ResponcesID [int] IDENTITY(1,1) NOT NULL,
    CreatedOn   [datetime],
    CreatedBy    varchar (20),
    SearchListID [int],
    ResponceType varchar(20),
    Automatic    bit not null,
    Subject varchar(255),
    SubjectFreeText bit NULL,
    Notes text,
	Type  varchar(50),
    StartAfterDays int,
    RecipientsLine varchar(255),
    UserRole1 varchar(50),
    UserRole2 varchar(50),
	UserRole3 varchar(50),
    RespOrder int
)ON [PRIMARY]
GO
ALTER TABLE [dbo].[Responces] WITH NOCHECK ADD 
	CONSTRAINT [PK_Responces] PRIMARY KEY  CLUSTERED 
	(
		[ResponcesID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Responces] ADD 
	CONSTRAINT [DF_Responces_CreatedOn] DEFAULT (getdate()) FOR [CreatedOn],
	CONSTRAINT [DF_Responces_Createdy] DEFAULT (suser_sname()) FOR [CreatedBy]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Responces]  TO [DeskFlowUsers]
GO
UPDATE LinkSearchListsToCandStage set IsList = 1
GO
INSERT INTO LinkSearchListsToCandStage(SearchListID,ListName) select Max(SearchListID)+1,'Placed' from LinkSearchListsToCandStage
GO
IF ( SELECT COUNT(*) FROM DataCashTables WHERE Name='Responces' )=0
INSERT INTO DataCashTables ( Name,UpdatedOn) VALUES('Responces',getdate())

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ResponcesTrigger]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[ResponcesTrigger]
GO
CREATE TRIGGER ResponcesTrigger ON [dbo].[Responces] 
FOR INSERT, UPDATE, DELETE 
AS

UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='Responces'
GO
