CREATE TABLE [dbo].[JobOrderSearch] (
	[JobOrderSearchID] [int] NOT NULL ,
	[FriendlyName] [varchar] (150) NULL ,
	[SQL] [text] NULL ,
	[FullQuery] [bit] NULL ,
	[TextSearch] [bit] NULL ,
	[FieldName] [varchar] (100) NULL ,
	[DataType] [varchar] (50) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrderSearch]  TO [DeskFlowUsers]
GO

GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrderSearch]  TO [DeskFlowUsers]
GO

IF NOT EXISTS( SELECT LastIDsID FROM LastIDs WITH(NOLOCK) WHERE FieldName LIKE 'JobOrderSearchID')
BEGIN
declare @LastID int
SET @LastID = (SELECT MAX(JobOrderSearchID) FROM JobOrderSearch WITH(NOLOCK))
INSERT INTO LastIDs ( FieldName, LastID )
VALUES('JobOrderSearchID', ISNULL(@LastID, 0))
END