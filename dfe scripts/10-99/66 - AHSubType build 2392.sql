ALTER TABLE ActivityHistory add SubType varchar(50)
GO
if ((select count(*) from DataCashTables  where Name='ActivitySubTypes')=0 )
insert into DataCashTables (Name ) Values ('ActivitySubTypes')
GO
CREATE TABLE [dbo].[ActivitySubTypes](
	[ActivitySubTypesID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityTypesID] [int] NULL,
	[SubTypeName] [varchar](50) NULL
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ActivitySubTypes]  TO [DeskFlowUsers]
GO
CREATE TRIGGER [dbo].[ActivityTypeDeleteTrigger] ON [dbo].[ActivityTypes]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
DELETE FROM ActivitySubTypes WHERE ActivityTypesID IN(SELECT ActivityTypesID FROM deleted)

