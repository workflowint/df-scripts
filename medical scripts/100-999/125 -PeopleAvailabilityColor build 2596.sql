CREATE TABLE [dbo].[PeopleAvailabilityStatus](
	[PeopleAvailabilityStatusID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleAvailabilityStatus] [varchar](50) NULL,
	[FontColor] [int] NULL,
 CONSTRAINT [PK_PeopleAvailabilityStatus] PRIMARY KEY CLUSTERED 
(
	[PeopleAvailabilityStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[PeopleAvailabilityStatus]  TO [DeskFlowUsers]
GO

if ( select COUNT(*) from PeopleAvailabilityStatus where PeopleAvailabilityStatus='Available')=0
insert into PeopleAvailabilityStatus ( PeopleAvailabilityStatus,FontColor)
values ('Available', 8388608)
if ( select COUNT(*) from PeopleAvailabilityStatus where PeopleAvailabilityStatus='Unavailable')=0
insert into PeopleAvailabilityStatus ( PeopleAvailabilityStatus,FontColor)
values ('Unavailable', 65280)

