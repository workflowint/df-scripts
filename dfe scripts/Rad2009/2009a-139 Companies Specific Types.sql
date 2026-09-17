/* ADD Permission Rights for Workgroups editing Company Specific Data */
ALTER TABLE GroupPermissions
ADD [ChangeCompanySpecific] [bit] NULL

GO


ALTER TABLE Companies
ADD [SpecificTypeID] [int] NULL

GO

/****** Object:  Table [dbo].[CompaniesSpecificType]   ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompaniesSpecificType](
	[CompaniesSpecificTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
	[TableName] [varchar](255) NULL,
	[FrameName] [varchar](255) NULL,
 CONSTRAINT [PK_CompaniesSpecificTypesID] PRIMARY KEY CLUSTERED 
(
		[CompaniesSpecificTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CompaniesSpecificType]  TO [DeskFlowUsers]


GO
/****** Object:  Trigger [dbo].[CompaniesSpecificTypeTrigger] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE TRIGGER [dbo].[CompaniesSpecificTypeTrigger] ON [dbo].[CompaniesSpecificType] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='CompaniesSpecificType'


GO
