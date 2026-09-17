ALTER Table Projects add ClnIntResultsSelected bit
GO

CREATE TABLE [dbo].[LinkClnResultsToProject](
	[LinkClnResultsToProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectsID] [int] NULL,
	[ClnInterviewResultsID] [int] NULL,
 CONSTRAINT [PK_LinkClnResultsToProject] PRIMARY KEY CLUSTERED 
(
	[LinkClnResultsToProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LinkClnResultsToProject_ProjectsID] ON [dbo].[LinkClnResultsToProject]
(
	[ProjectsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkClnResultsToProject] TO [DeskFlowUsers]
