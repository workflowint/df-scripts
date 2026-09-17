EXEC sp_rename 'NoteTypes', 'NoteTypes1'
GO
CREATE TABLE [dbo].[NoteTypes](
	[NoteTypesID] [int] NOT NULL identity(1,1),
	[NoteTypes] [varchar](50) NULL,
 CONSTRAINT [PK_NoteTypes1] PRIMARY KEY CLUSTERED 
(
	[NoteTypesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[NoteTypes]  TO [DeskFlowUsers]
GO
insert into NoteTypes(NoteTypes)
select NoteTypes from NoteTypes1
GO
drop table NoteTypes1
GO
ALTER TABLE Responces add TimePeriod varchar(10)
go 
UPDATE Responces set TimePeriod = 'Days'
