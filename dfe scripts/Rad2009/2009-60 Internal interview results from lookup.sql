
CREATE TABLE [dbo].[IntIntResultsLookup] (
	[IntIntLookupResultsID] [int] IDENTITY (1, 1) NOT NULL ,
	[IntInterviewResultsID] [int] NOT NULL ,
	[LookupResValue] [varchar] (100) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IntInterviewResults] (
	[IntInterviewResultsID] [int] IDENTITY (1, 1) NOT NULL ,
	[IntResultName] [varchar] (100) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LinkInternalInterviewsToResults] (
	[LinkIntInterviewsToResultsID] [int] IDENTITY (1, 1) NOT NULL ,
	[InternalInterviewsID] [int] NOT NULL ,
	[IntInterviewResultsID] [int] NULL ,
	[IntIntLookupResultsID] [int] NULL ,
	[ShortResNotes] [varchar] (255) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[IntIntResultsLookup] WITH NOCHECK ADD 
	CONSTRAINT [PK_IntIntResultsLookup] PRIMARY KEY  CLUSTERED 
	(
		[IntIntLookupResultsID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IntInterviewResults] WITH NOCHECK ADD 
	CONSTRAINT [PK_IntInterviewResults] PRIMARY KEY  CLUSTERED 
	(
		[IntInterviewResultsID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[LinkInternalInterviewsToResults] WITH NOCHECK ADD 
	CONSTRAINT [PK_LinkInternalInterviewsToResults] PRIMARY KEY  CLUSTERED 
	(
		[LinkIntInterviewsToResultsID]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_IntIntResultsLookup] ON [dbo].[IntIntResultsLookup]([IntInterviewResultsID]) ON [PRIMARY]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[IntIntResultsLookup]  TO [DeskFlowUsers]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[IntInterviewResults]  TO [DeskFlowUsers]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkInternalInterviewsToResults]  TO [DeskFlowUsers]
GO

