/****** Object:  Table [dbo].[ProgramData]    Script Date: 3/27/2018 3:43:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProgramData64](
	[ProgramData64ID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](50) NOT NULL,
	[ModifiedOn] [datetime] NULL,
	[Data] [image] NULL,
 CONSTRAINT [ProgramData64ID] PRIMARY KEY NONCLUSTERED 
(
	[ProgramData64ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Elena's permission change
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ProgramData64]  TO [DeskFlowUsers]

GO