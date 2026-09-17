ALTER TABLE People
ADD [CustomBool1] [bit] NULL DEFAULT (0),
	[CustomBool2] [bit] NULL DEFAULT (0),
	[CustomLookup1] [varchar](100) NULL,
	[CustomLookup2] [varchar](100) NULL,
	[CustomLookup3] [varchar](100) NULL,
	[CustomLookup4]	[varchar](100) NULL,
	[CustomLookup5] [varchar](100) NULL
	
GO

-- Create generic lookups for people

GO
/****** Object:  Table [dbo].[People_CustomLookup1]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[People_CustomLookup1](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_People_CustomLookup1] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[People_CustomLookup1]  TO [DeskFlowUsers]


GO
/****** Object:  Table [dbo].[People_CustomLookup2]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[People_CustomLookup2](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_People_CustomLookup2] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[People_CustomLookup2]  TO [DeskFlowUsers]


GO
/****** Object:  Table [dbo].[People_CustomLookup3]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[People_CustomLookup3](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_People_CustomLookup3] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[People_CustomLookup3]  TO [DeskFlowUsers]


GO
/****** Object:  Table [dbo].[People_CustomLookup4]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[People_CustomLookup4](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_People_CustomLookup4] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[People_CustomLookup4]  TO [DeskFlowUsers]


GO
/****** Object:  Table [dbo].[People_CustomLookup5]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[People_CustomLookup5](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_People_CustomLookup5] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[People_CustomLookup5]  TO [DeskFlowUsers]

GO

-- Insert lookups into table for administrator

IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'People_CustomLookup1' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('People_CustomLookup1', 'CustomLookup1 on PEOPLE extra tab', 'Description', 'Description' )
END 

GO 

IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'People_CustomLookup2' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('People_CustomLookup2', 'CustomLookup2 on PEOPLE extra tab', 'Description', 'Description' )
END

GO 

IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'People_CustomLookup3' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('People_CustomLookup3', 'CustomLookup3 on PEOPLE extra tab', 'Description', 'Description' )
END

GO 

IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'People_CustomLookup4' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('People_CustomLookup4', 'CustomLookup4 on PEOPLE extra tab', 'Description', 'Description' )
END

GO 

IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'People_CustomLookup5' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('People_CustomLookup5', 'CustomLookup5 on PEOPLE extra tab', 'Description', 'Description' )
END

GO

