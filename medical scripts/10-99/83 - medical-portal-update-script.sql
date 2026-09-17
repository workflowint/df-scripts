SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- WebApplications fields

ALTER TABLE WebApplications add
	[CustomText1] [varchar](255) NULL
go
alter table WebApplications add
	[CustomText2] [varchar](255) NULL
go
alter table WebApplications add
	[CustomText3] [varchar](255) NULL
go
alter table WebApplications add
	[CustomText4] [varchar](255) NULL
go
alter table WebApplications add
	[CustomText5] [varchar](255) NULL
go
alter table WebApplications add
	[CustomDate1] [datetime] NULL
go
alter table WebApplications add
	[CustomDate2] [datetime] NULL
go
alter table WebApplications add
	[CustomDate3] [datetime] NULL
go
alter table WebApplications add
	[CustomDate4] [datetime] NULL
go
alter table WebApplications add
	[Bilingual] [char](1) NULL
go
alter table WebApplications add
	[Relocate] [varchar](150) NULL
go
alter table WebApplications add
	AltEmailAddress [varchar](100) NULL
go
alter table WebApplications add
	[MinSalary] [money] NULL
go
alter table WebApplications add
	[MinRate] [money] NULL
go
ALTER TABLE WebApplications
ADD Photo varbinary(MAX) NULL

GO


	ALTER TABLE [dbo].[WebApplications] ADD  CONSTRAINT [DF_WebApplications_Bilingual]  DEFAULT ('N') FOR [Bilingual]
GO


-- Duplicates fields
ALTER TABLE Duplicates
ADD Photo varbinary(MAX) NULL

GO




-- WebLogins fields

ALTER TABLE WebLogins
ADD Photo varbinary(MAX) NULL
go
ALTER TABLE WebLogins add
	Gender varchar(1) NULL
go
ALTER TABLE WebLogins add
	Birthday datetime NULL
	
GO

alter table WebLogins
add 	[Address1] [varchar](50) NULL,
	[PostalCode] [varchar](20) NULL,
	[Country] [varchar](30) NULL

	go

-- JobOrders fields

ALTER TABLE JobOrders add	WebTemplateID [int], WebSubject [varchar](255),
	WebFormat [int]
go

-- ApplicantAlerts fields
ALTER TABLE [dbo].[ApplicantAlerts] ADD  CONSTRAINT [DF_ApplicantAlerts_RetryCount]  DEFAULT ((0)) FOR [RetryCount]
GO

UPDATE ApplicantAlerts SET RetryCount = 0 WHERE RetryCount IS NULL
GO


-- People update trigger to sync WebLogins

if object_id('PeopleUpdateWebLogin') is not null
	drop trigger PeopleUpdateWebLogin
go

create TRIGGER [dbo].[PeopleUpdateWebLogin] ON [dbo].[People]
FOR UPDATE 
AS
BEGIN

UPDATE WebLogins
SET  
	LoginName = Inserted.WebLoginName
FROM Inserted JOIN Deleted ON
( Inserted.PeopleID = Deleted.PeopleID
	AND ( Inserted.WebLoginName <> Deleted.WebLoginName ) 
)
WHERE WebLogins.LoginName = Deleted.WebLoginName
	AND NOT EXISTS (
		SELECT LoginName 
		FROM WebLogins WITH(NOLOCK) 
		WHERE LoginName = Inserted.WebLoginName
	) 

END

go
