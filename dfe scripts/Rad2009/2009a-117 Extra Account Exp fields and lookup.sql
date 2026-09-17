ALTER TABLE LinkPeopleToCompanies
 ADD CustomInt1 int NULL, CustomInt2 int NULL,
	CustomBit1 bit NULL, CustomBit2 bit NULL, CustomBit3 bit NULL, CustomBit4 bit NULL,
	CustomLookup1 varchar(255) NULL, CustomLookup2 varchar(255) NULL

GO
/****** Object:  Table [dbo].[AccExpCustomLookup1]    Script Date: 07/03/2014 18:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccExpCustomLookup1](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_AccExpCustomLookup1] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF	
 
 
GO
/****** Object:  Table [dbo].[AccExpCustomLookup2]    Script Date: 07/03/2014 18:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccExpCustomLookup2](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_AccExpCustomLookup2] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF	
 
 
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[AccExpCustomLookup1]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[AccExpCustomLookup2]  TO [DeskFlowUsers]
GO
