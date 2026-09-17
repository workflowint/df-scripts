ALTER TABLE Projects add FontColor int
GO
CREATE TABLE [dbo].[ProjectTrackerColors](
	[ProjectTrackerColorsID] [int] IDENTITY(1,1) NOT NULL,
	[Color] [int] NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_ProjectTrackerColors] PRIMARY KEY CLUSTERED 
(
	[ProjectTrackerColorsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ProjectTrackerColors]  TO [DeskFlowUsers]
GO
if ( select count(*) from LookupTables where name='ProjectTrackerColors') =0 
INSERT INTO LookupTables ( Name, Description, Editable, Visible )
VALUES ('ProjectTrackerColors', 'Project Tracker Colors','Description','Description')
