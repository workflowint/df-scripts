CREATE TABLE [dbo].[LinkMedApplicationsToRates](
	[RateTypesID] [int] NOT NULL,
	[MedApplicationsID] [int] NOT NULL,	
	[PeopleID] [int] NOT NULL,
	[RateValue] [money] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar] (20) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](20) NULL,
	[UTCCreatedOn] [smallint] NULL,
	[UTCUpdatedOn] [smallint] NULL,
 CONSTRAINT [PK_LinkMedApplicationsToRates] PRIMARY KEY NONCLUSTERED 
(
	[RateTypesID] ASC,
	[MedApplicationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LinkMedApplicationsToRates] ADD  CONSTRAINT [DF_LinkMedApplicationsToRates_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[LinkMedApplicationsToRates] ADD  CONSTRAINT [DF_LinkMedApplicationsToRates_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[LinkMedApplicationsToRates] ADD  CONSTRAINT [DF_LinkMedApplicationsToRates_UpdatedOn]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[LinkMedApplicationsToRates] ADD  CONSTRAINT [DF_LinkMedApplicationsToRates_UpdatedBy]  DEFAULT (suser_sname()) FOR [UpdatedBy]
GO
ALTER TABLE [dbo].[LinkMedApplicationsToRates] ADD  DEFAULT ((1)) FOR [UTCCreatedOn]
GO
ALTER TABLE [dbo].[LinkMedApplicationsToRates] ADD  DEFAULT ((1)) FOR [UTCUpdatedOn]
GO
GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[LinkMedApplicationsToRates] TO [DeskFlowUsers]
GO
CREATE TRIGGER [dbo].[MedApplicationsDelete] ON [dbo].[MedApplications]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
DELETE FROM LinkMedApplicationsToRates WHERE MedApplicationsID IN(SELECT MedApplicationsID FROM deleted)



