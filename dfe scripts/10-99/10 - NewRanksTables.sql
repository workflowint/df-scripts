
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Ranks2](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL
 CONSTRAINT [PK_Ranks2] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[Ranks3](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL
 CONSTRAINT [PK_Ranks3] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ranks4](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL
 CONSTRAINT [PK_Ranks4] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Ranks5](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL
 CONSTRAINT [PK_Ranks5] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Ranks6](
	[RanksID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL
 CONSTRAINT [PK_Ranks6] PRIMARY KEY CLUSTERED 
(
	[RanksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Ranks2]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Ranks3]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Ranks4]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Ranks5]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Ranks6]  TO [DeskFlowUsers]
GO
SET ANSI_PADDING OFF
GO
if ( select COUNT(*) from Ranks2 )=0
INSERT INTO Ranks2 ( description)
select description from Ranks
GO
if ( select COUNT(*) from Ranks3 )=0
INSERT INTO Ranks3 ( description)
select description from Ranks
GO
if ( select COUNT(*) from Ranks4 )=0
INSERT INTO Ranks4 ( description)
select description from Ranks
GO
if ( select COUNT(*) from Ranks5 )=0
INSERT INTO Ranks5 ( description)
select description from Ranks
GO
if ( select COUNT(*) from Ranks6 )=0
INSERT INTO Ranks6 ( description)
select description from Ranks
GO
if ( select COUNT(*) from LookupTables where Name ='Ranks2')=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible, CanDelete)
VALUES ('Ranks2','Values for Projects Rank2','Description','Description',1)
GO
if ( select COUNT(*) from LookupTables where Name ='Ranks3')=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible, CanDelete)
VALUES ('Ranks3','Values for Projects Rank3','Description','Description',1)
GO
if ( select COUNT(*) from LookupTables where Name ='Ranks4')=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible, CanDelete)
VALUES ('Ranks4','Values for Projects Rank4','Description','Description',1)
GO
if ( select COUNT(*) from LookupTables where Name ='Ranks5')=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible, CanDelete)
VALUES ('Ranks5','Values for Projects DFENow1','Description','Description',1)
GO
if ( select COUNT(*) from LookupTables where Name ='Ranks6')=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible, CanDelete)
VALUES ('Ranks6','Values for Projects DFENow2','Description','Description',1)






