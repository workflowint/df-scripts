ALTER TABLE LinkPeopleToNetWork add Type varchar(50)
GO
ALTER TABLE JobOrders add SCROriginalText text
GO

CREATE TABLE [dbo].[NetWorkTypes](
	[NetWorkTypeID] [int] IDENTITY(1,1) NOT NULL,
	[NetWorkType] [varchar](50)  NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[NetWorkTypes] WITH NOCHECK ADD 
	CONSTRAINT [PK_NetWorkTypeID] PRIMARY KEY  CLUSTERED 
	(
		[NetWorkTypeID]
	)  ON [PRIMARY] 
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[NetWorkTypes]  TO [DeskFlowUsers]
GO
GO
IF (select count(*) from LookupTables where name = 'NetWorkTypes' )=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible)
Values ('NetWorkTypes','Type for NetWork','NetWorkType','NetWorkType')

