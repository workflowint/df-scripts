ALTER TABLE Companies
ADD SalesSourceID int NULL

GO

/****** Object:  Table [dbo].[SalesSource]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesSource](
	[SalesSourceID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_SalesSourceID] PRIMARY KEY CLUSTERED 
(
		[SalesSourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[SalesSource]  TO [DeskFlowUsers]

GO

/****** Object:  Trigger [dbo].[SalesSourceTrigger] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE TRIGGER [dbo].[SalesSourceTrigger] ON [dbo].[SalesSource] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='SalesSource'

GO

INSERT INTO DataCashTables (Name) VALUES ('SalesSource')