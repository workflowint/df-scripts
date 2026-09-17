ALTER TABLE companies add AttentionField bit
GO
ALTER TABLE People add VaccineStatus varchar(50)
GO
CREATE TABLE [dbo].[VaccineStatus](
	[VaccineStatusID] [int] IDENTITY(1,1) NOT NULL,
	[VaccineStatus] [nvarchar](50) NULL,
	[ShowImage] [bit] NULL,
 CONSTRAINT [PK_VaccineStatus] PRIMARY KEY CLUSTERED 
(
	[VaccineStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[VaccineStatus]  TO [DeskFlowUsers]
GO
If ( select count(*) from LookupTables where name='VaccineStatus')=0
insert into LookupTables (Name, Description,Visible,Editable)
Values ('VaccineStatus', 'Person Vaccination Status','VaccineStatus','VaccineStatus')