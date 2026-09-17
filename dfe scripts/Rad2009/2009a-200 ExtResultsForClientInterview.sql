ALTER TABLE IntInterviewResults add Type varchar(50), ResultNumber int

GO
CREATE TABLE [dbo].[ClnInterviewResults](
	[ClnInterviewResultsID] [int] IDENTITY(1,1) NOT NULL,
	[IntResultName] [varchar](100) NULL,
	[PrePopulate] [bit] NULL,
	[Type][varchar](50),
	[ResultNumber] int
 CONSTRAINT [PK_ClnInterviewResults] PRIMARY KEY CLUSTERED 
(
	[ClnInterviewResultsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ClnInterviewResults] ADD  DEFAULT ((0)) FOR [PrePopulate]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ClnInterviewResults]  TO [DeskFlowUsers]
GO
CREATE TABLE [dbo].[ClnIntResultsLookup](
	[ClnIntLookupResultsID] [int] IDENTITY(1,1) NOT NULL,
	[ClnInterviewResultsID] [int] NOT NULL,
	[LookupResValue] [varchar](100) NULL,
 CONSTRAINT [PK_ClnIntResultsLookup] PRIMARY KEY CLUSTERED 
(
	[ClnIntLookupResultsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ClnIntResultsLookup]  TO [DeskFlowUsers]
GO

CREATE TABLE [dbo].[LinkClnInterviewsToResults](
	[LinkClnInterviewsToResultsID] [int] IDENTITY(1,1) NOT NULL,
	[InterviewsID] [int] NOT NULL,
	[ClnInterviewResultsID] [int] NULL,
	[ClnIntLookupResultsID] [int] NULL,
	[ShortResNotes] [text] NULL,
 CONSTRAINT [PK_LinkClnInterviewsToResults] PRIMARY KEY CLUSTERED 
(
	[LinkClnInterviewsToResultsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkClnInterviewsToResults]  TO [DeskFlowUsers]
GO


