ALTER TABLE JobOrders add	CustomText1 varchar(255), CustomText2 varchar(255),
	CustomText3 varchar(255),CustomText4 varchar(255),CustomText5 varchar(255),	
	CustomText6 varchar(255),CustomText7 varchar(255) ,
	CustomMemo1 text,CustomMemo2 text,
	CustomDate1 datetime,CustomDate2 datetime,CustomDate3 datetime,
	CustomDate4 datetime,CustomInt1 int,CustomInt2 int,
	CustomCurrency1 money,CustomCurrency2 money,CustomFloat1 float,CustomFloat2 float, 
	CustomBool1 bit,CustomBool2 bit, CustomLookup1 varchar(100),
	CustomLookup2 varchar(100),CustomLookup3 varchar(100),
	CustomLookup4 varchar(100),CustomLookup5 varchar(100),
	CustomLookup6 varchar(100)

GO
CREATE TABLE [dbo].[JobOrder_CustomLookup1](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_JobOrder_CustomLookup1] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrder_CustomLookup1]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'JobOrder_CustomLookup1' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('JobOrder_CustomLookup1', 'CustomLookup1 on Job Order extra tab', 'Description', 'Description' )
END
GO
CREATE TABLE [dbo].[JobOrder_CustomLookup2](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_JobOrder_CustomLookup2] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrder_CustomLookup2]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'JobOrder_CustomLookup2' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('JobOrder_CustomLookup2', 'CustomLookup2 on Job Order extra tab', 'Description', 'Description' )
END
GO
CREATE TABLE [dbo].[JobOrder_CustomLookup3](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_JobOrder_CustomLookup3] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrder_CustomLookup3]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'JobOrder_CustomLookup3' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('JobOrder_CustomLookup3', 'CustomLookup3 on Job Order extra tab', 'Description', 'Description' )
END
GO
CREATE TABLE [dbo].[JobOrder_CustomLookup4](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_JobOrder_CustomLookup4] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrder_CustomLookup4]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'JobOrder_CustomLookup4' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('JobOrder_CustomLookup4', 'CustomLookup4 on Job Order extra tab', 'Description', 'Description' )
END
GO
CREATE TABLE [dbo].[JobOrder_CustomLookup5](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_JobOrder_CustomLookup5] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrder_CustomLookup5]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'JobOrder_CustomLookup5' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('JobOrder_CustomLookup5', 'CustomLookup5 on Job Order extra tab', 'Description', 'Description' )
END
GO
CREATE TABLE [dbo].[JobOrder_CustomLookup6](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_JobOrder_CustomLookup6] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrder_CustomLookup6]  TO [DeskFlowUsers]


IF NOT EXISTS( SELECT * FROM LookupTables WHERE Name = 'JobOrder_CustomLookup6' )
BEGIN
	INSERT INTO LookupTables ( Name, Description, Editable, Visible ) 
	VALUES ('JobOrder_CustomLookup6', 'CustomLookup6 on Job Order extra tab', 'Description', 'Description' )
END
