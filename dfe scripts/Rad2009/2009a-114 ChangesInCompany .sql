ALTER TABLE Companies ALTER COLUMN Benefits varchar(max)
go
ALTER TABLE Companies ALTER COLUMN InsuranceBenefits varchar(max)
go
ALTER TABLE Companies ALTER COLUMN OtherBenefits varchar(max)
go
ALTER TABLE Notes add Type varchar(50)
go
CREATE TABLE [dbo].[NoteTypes](
	[NoteTypesID] [int] NOT NULL,
	[NoteTypes] [varchar](50) NULL,
 CONSTRAINT [PK_NoteTypes] PRIMARY KEY CLUSTERED 
(
	[NoteTypesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[NoteTypes]  TO [DeskFlowUsers]
GO
ALTER TABLE Companies add CustomDate5 datetime, CustomDate6 datetime,CustomDate7 datetime,CustomDate8 datetime,
                          CustomDate9 datetime,CustomDate10 datetime
GO
GO
if ( select count(*) from LookupTables where name='NoteTypes')=0
INSERT INTO LookupTables(Name,description,Editable,Visible,Candelete)
VALUES ('NoteTypes','Note Types','NoteTypes','NoteTypes',1)
