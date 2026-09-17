ALTER TABLE Positions add Progress varchar(50)
GO
CREATE TABLE [dbo].[JobOrderProgress](
	[JobOrderProgressID] [int] IDENTITY(1,1) NOT NULL,
	[ProgressDescription] [varchar](50) NULL,
	Color int
 CONSTRAINT [PK_JobOrderProgress] PRIMARY KEY CLUSTERED 
(
	[JobOrderProgressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrderProgress]  TO [DeskFlowUsers]
GO
if ( select COUNT(*) from LookupTables where Name ='JobOrderProgress')=0
INSERT INTO LookupTables ( Name,Description,Editable,Visible, CanDelete)
VALUES ('JobOrderProgress','Values for JobOrder Progress','ProgressDescription','ProgressDescription',1)
GO
ALTER TABLE ClientConfig add CallStatusFourthImage int
go
update ClientConfig set CallStatusFourthImage =0
