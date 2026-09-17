/****** Object:  Table [dbo].[TrainingStatus]    Script Date: 13/4/21 2:17:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TrainingStatus](
	[TrainingStatusID] [int] IDENTITY(1,1) NOT NULL,
	[TrainingStatus] [varchar](50) NULL,
 CONSTRAINT [PK_TrainingStatus] PRIMARY KEY CLUSTERED 
(
	[TrainingStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[TrainingStatus] TO [DeskFlowUsers]
GO
if ( select count(*) from LookupTables where Name='TrainingStatus')=0
Insert into LookupTables (Name,Description,Editable,Visible,CanDelete)
values ('TrainingStatus', 'Training Status','TrainingStatus','TrainingStatus',1)
GO
if ( select  count(*) from TrainingStatus)=0
	begin
	 insert into TrainingStatus (TrainingStatus) values ('AT')
	 insert into TrainingStatus (TrainingStatus) values ('FT')
	end

