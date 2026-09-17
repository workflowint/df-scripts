/****** Object:  Table [dbo].[PayEquityLaws]    Script Date: 11/23/2017 12:13:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PayEquityLaws](
	[PayEquityLawsID] [int] NOT NULL,
	[EffectiveDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[Country] [varchar](50) NULL,
	[Province] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Notes] [varchar](max) NULL,
 CONSTRAINT [PK_PayEquityLaws] PRIMARY KEY CLUSTERED 
(
	[PayEquityLawsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PayEquityLaws]  TO [DeskFlowUsers]
GO
CREATE TABLE [dbo].[PayEquityLawsType](
	[PayEquityLawTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_PayEquityLawsType] PRIMARY KEY CLUSTERED 
(
	[PayEquityLawTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PayEquityLawsType]  TO [DeskFlowUsers]
GO
if ( select COUNT(*) from LastIDs where FieldName='PayEquityLawsID')=0
insert into LastIDs(FieldName,LastID ) values ('PayEquityLawsID',0)
GO
IF (select count(*) from LookupTables where name = 'PayEquityLawsType' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('PayEquityLawsType','Pay Equity Laws Type','Description','Description')
GO
CREATE NONCLUSTERED INDEX [IX_PayEquityLaws_Country] ON [dbo].[PayEquityLaws] 
(
	[Country] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PayEquityLaws_Province] ON [dbo].[PayEquityLaws] 
(
	[Province] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PayEquityLaws_City] ON [dbo].[PayEquityLaws] 
(
	[City] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
if ( select COUNT(*) from ProgramComponents where Name='Pay Equity')=0
insert into ProgramComponents (Name ) values ('Pay Equity')
