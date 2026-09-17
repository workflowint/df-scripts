/****** Object:  Table [dbo].[JobOrdersCompaniesLists]    Script Date: 05/02/2014 16:45:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JobOrdersCompaniesLists](
	[JobOrdersID] [int] NOT NULL,
	[CompaniesID] [int] NOT NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_JobOrdersCompaniesLists_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [varchar](20) NULL CONSTRAINT [DF_JobOrdersCompaniesLists_CreatedBy]  DEFAULT (suser_sname()),
	[Rank] [varchar](10) NULL,
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_JobOrdersCompaniesLists_UpdatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [varchar](20) NULL CONSTRAINT [DF_JobOrdersCompaniesLists_UpdatedBy]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_JobOrdersCompaniesLists] PRIMARY KEY NONCLUSTERED 
(
	[JobOrdersID] ASC,
	[CompaniesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO
/****** Object:  Trigger [dbo].[JobOrdersCompaniesListsDelete]    Script Date: 05/02/2014 16:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[JobOrdersCompaniesListsDelete] ON [dbo].[JobOrdersCompaniesLists]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @JobOrdersID         int
declare @CompaniesID	  int

declare Row cursor local  for
     select  JobOrdersID, CompaniesID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @JobOrdersID, @CompaniesID

while @@fetch_status = 0
    begin

         delete from JobOrdersTargetCompaniesCandidates
             where JobOrdersID =  @JobOrdersID and CompaniesID = @CompaniesID

         fetch next from Row into @JobOrdersID, @CompaniesID

    end
          
close            Row
deallocate  Row


GO
/****** Object:  Trigger [dbo].[JobOrdersCompaniesListsUpdate]    Script Date: 05/02/2014 16:51:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  TRIGGER [dbo].[JobOrdersCompaniesListsUpdate] ON [dbo].[JobOrdersCompaniesLists]
FOR UPDATE
AS

update JobOrdersCompaniesLists set 
             JobOrdersCompaniesLists.UpdatedBy = suser_sname(),
             JobOrdersCompaniesLists.UpdatedOn = getdate()
FROM Inserted, JobOrdersCompaniesLists 
WHERE Inserted.CompaniesID = JobOrdersCompaniesLists.CompaniesID
AND Inserted.JobOrdersID	= JobOrdersCompaniesLists.JobOrdersID	


GO
/****** Object:  Table [dbo].[JobOrdersTargetCompaniesCandidates]    Script Date: 05/02/2014 17:11:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JobOrdersTargetCompaniesCandidates](
	[JobOrdersID] [int] NOT NULL,
	[CompaniesID] [int] NOT NULL,
	[PeopleID] [int] NOT NULL,
	[Rank] [char](10) NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_JobOrdersTargetCompaniesCandidates_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [varchar](20) NULL CONSTRAINT [DF_JobOrdersTargetCompaniesCandidates_CreatedBy]  DEFAULT (suser_sname()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_JobOrdersTargetCompaniesCandidates_UpdatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [varchar](20) NULL CONSTRAINT [DF_JobOrdersTargetCompaniesCandidates_UpdatedBy]  DEFAULT (suser_sname()),
	[Rank2] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

GO
/****** Object:  Trigger [dbo].[JobOrdersTargetCompaniesCandidatesUpdate]    Script Date: 05/02/2014 17:16:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  TRIGGER [dbo].[JobOrdersTargetCompaniesCandidatesUpdate] ON [dbo].[JobOrdersTargetCompaniesCandidates]
FOR UPDATE
AS

update JobOrdersTargetCompaniesCandidates set 
             JobOrdersTargetCompaniesCandidates.UpdatedBy = suser_sname(),
             JobOrdersTargetCompaniesCandidates.UpdatedOn = getdate()
FROM Inserted, JobOrdersTargetCompaniesCandidates 
WHERE Inserted.PeopleID = JobOrdersTargetCompaniesCandidates.PeopleID
AND Inserted.JobOrdersID	= JobOrdersTargetCompaniesCandidates.JobOrdersID	


GO
/****** Object:  Table [dbo].[JobOrdersSources]    Script Date: 05/05/2014 13:48:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JobOrdersSources](
	[PeopleID] [int] NOT NULL,
	[JobOrdersID] [int] NOT NULL,
	[CreatedOn] [datetime] NULL CONSTRAINT [DF_JobOrdersSources_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [varchar](20) NULL CONSTRAINT [DF_JobOrdersSources_CreatedBy]  DEFAULT (suser_sname()),
	[UpdatedOn] [datetime] NULL CONSTRAINT [DF_JobOrdersSources_UpdatedOn]  DEFAULT (getdate()),
	[UpdatedBy] [varchar](20) NULL CONSTRAINT [DF_JobOrdersSources_UpdatedBy]  DEFAULT (suser_sname()),
	[Rank] [varchar](100) NULL,
	[Rank2] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


GO
/****** Object:  Trigger [dbo].[JobOrdersSourcesUpdate]    Script Date: 05/05/2014 13:51:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[JobOrdersSourcesUpdate] ON [dbo].[JobOrdersSources]
FOR UPDATE
AS

update JobOrdersSources set 
       JobOrdersSources.UpdatedBy = suser_sname(),
       JobOrdersSources.UpdatedOn = getdate()
FROM Inserted, JobOrdersSources 
WHERE Inserted.PeopleID = JobOrdersSources.PeopleID
AND Inserted.JobOrdersID	= JobOrdersSources.JobOrdersID	


GO
/****** Object:  Trigger [dbo].[JobOrdersDelete]    Script Date: 05/05/2014 13:53:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER                   TRIGGER [dbo].[JobOrdersDelete] ON [dbo].[JobOrders]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @JobOrdersID         int

declare Row cursor local  for
     select   JobOrdersID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @JobOrdersID

while @@fetch_status = 0
    begin

         delete from Interview                               	where JobOrdersID =  @JobOrdersID
         delete from JobOrderConsideredPeople       	where JobOrdersID =  @JobOrdersID
         delete from JobOrderPresentedPeople         	where JobOrdersID =  @JobOrdersID
         delete from JobOrderInterviewPeople           	where JobOrdersID =  @JobOrdersID
         delete from JobOrderInternalInterviewPeople 	where JobOrdersID =  @JobOrdersID
         delete from PeopleAppliedTo                    where JobOrdersID =  @JobOrdersID
         delete from LinkObjectToActivityHistory       	where LeftID = @JobOrdersID and ObjectTableName = 'JobOrders'
         delete from LinkObjectToDocument             	where LeftID = @JobOrdersID and ObjectTableName = 'JobOrders'
         delete from CandidateReferrals	           	where JobOrdersID = @JobOrdersID	
         delete from JobRequirements	           	where JobOrdersID = @JobOrdersID
         delete from WebJobPostings                     where JobOrdersID = @JobOrdersID
         delete from TimeSheets                         where JobOrdersID = @JobOrdersID
         delete from Assignments                        where JobOrdersID = @JobOrdersID
         delete from LinkJobOrdersToRates       where JobOrdersID = @JobOrdersID
         delete from JobOrderSchedule              where JobOrdersID = @JobOrdersID
         delete from JobOrderClientTeams          where JobOrdersID = @JobOrdersID
         delete from JobOrderTeams                   where JobOrdersID = @JobOrdersID
		 delete from JobOrdersCompaniesLists		where JobOrdersID = @JobOrdersID
		 delete from JobOrdersSources				where JobOrdersID = @JobOrdersID
         delete from LinkJobOrderToWorksteps      	where JobOrdersID = @JobOrdersID
         delete from LinkObjectToTask		        where LeftID = @JobOrdersID and ObjectTableName = 'JobOrders'
         delete from Positions                          where JobOrdersID = @JobOrdersID
         delete from ListsDetails 			where RecordID = @JobOrdersID AND ListID IN 
        ( SELECT ListsID FROM Lists WHERE SourceTable = 'MRContracts' OR SourceTable = 'Temp' OR SourceTable = 'PermOrders' OR
	SourceTable='Contracts')
         delete from LinkOpportunitiesToBusinessObjects where JobOrdersID = @JobOrdersID
         delete from LinkEventsToBusinessObjects where JobOrdersID = @JobOrdersID
         update Task SET JobOrdersID = NULL 		where JobOrdersID = @JobOrdersID
         update WebRequests SET JobOrdersID = NULL 	where JobOrdersID = @JobOrdersID
         fetch next from Row into @JobOrdersID

    end
          
close       Row
deallocate  Row



GO
/****** Object:  Trigger [dbo].[CompaniesDelete]    Script Date: 05/05/2014 13:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------------------------
    When a Companies record is deleted, this deletes all records
    linked to the deleted record.
   --------------------------------------------------------------------------------------------------------*/
ALTER                    TRIGGER [dbo].[CompaniesDelete] ON [dbo].[Companies]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @CompaniesID         int

declare Row cursor local  for
     select   CompaniesID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @CompaniesID

while @@fetch_status = 0
    begin

         delete from Addresses				where CompaniesID =  @CompaniesID
         delete from CompaniesIndustry			where CompaniesID =  @CompaniesID
         delete from CompaniesAliases          		where CompaniesID =  @CompaniesID
         delete from LinkCompaniesToRates          	where CompaniesID =  @CompaniesID
         delete from EMailAddress				where CompaniesID = @CompaniesID
         delete from LinkObjectToActivityHistory	where LeftID = @CompaniesID and ObjectTableName = 'Companies'
         delete from LinkObjectToDocument			where LeftID = @CompaniesID and ObjectTableName = 'Companies'
         delete from LinkCompaniesToAttributes		where CompaniesID= @CompaniesID	
         delete from ClientContactTeams			where CompaniesID= @CompaniesID
         delete from LinkPeopleToCompanies		where CompaniesID= @CompaniesID
         delete from LinkCompaniesToOpportunities	where CompaniesID= @CompaniesID
	 delete from ProjectsCompaniesLists             where CompaniesID= @CompaniesID
		delete from JobOrdersCompaniesLists			where CompaniesID= @CompaniesID
         delete from LinkObjectToTask		        where LeftID = @CompaniesID and ObjectTableName = 'Companies'
         delete from LinkCompanyToCompanies		where CompaniesID = @CompaniesID or LinkedCompaniesID = @CompaniesID
	 delete from ListsDetails		where RecordID IN( SELECT CompaniesID FROM Deleted)
 							AND ListID IN ( SELECT ListsID FROM Lists WHERE SourceTable = 'Companies')
	   
	
         fetch next from Row into @CompaniesID

    end
          
close            Row
deallocate  Row



GO
/****** Object:  Trigger [dbo].[PeopleDelete]    Script Date: 05/05/2014 13:56:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------------------------
    When a People record is deleted, this deletes all records
    linked to the deleted record.
   --------------------------------------------------------------------------------------------------------*/
ALTER                   TRIGGER [dbo].[PeopleDelete] ON [dbo].[People]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
begin
	
     delete from Addresses 		where AddressesID IN (SELECT HomeAddressesID from Deleted)
      delete from Addresses 		where AddressesID IN (SELECT BusinessAddressesID from Deleted)
      delete from Addresses 		where AddressesID IN (SELECT AlternativeAddressesID from Deleted)
      delete from Resumes		where PeopleID IN( SELECT PeopleID FROM Deleted)
      delete from Positions		where PeopleID IN( SELECT PeopleID FROM Deleted)
       
	delete from EMailAddress			where PeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from Notes					where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from LinkObjectToActivityHistory	where LeftID IN( SELECT PeopleID FROM Deleted) and ObjectTableName = 'People'
     	delete from LinkObjectToDocument		where LeftID IN( SELECT PeopleID FROM Deleted) and ObjectTableName = 'People'
	delete from LinkPeopleToNetWork		where LeftID IN( SELECT PeopleID FROM Deleted)
	
	delete from LinkPeopleToNetWork	where RightID IN( SELECT PeopleID FROM Deleted)
	delete from LinkPeopleToSkills	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from ListsDetails		where RecordID IN( SELECT PeopleID FROM Deleted)
							AND ListID IN ( SELECT ListsID FROM Lists WHERE SourceTable = 'People')

	delete from JobOrderConsideredPeople	 	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from JobOrderInterviewPeople			where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from JobOrderInternalInterviewPeople 	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from JobOrderPresentedPeople			where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from ProjectsClientTeams			where PeopleID IN( SELECT PeopleID FROM Deleted)
        
	delete from ProjectsBenchmarkCandidates    	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from ProjectsInternalInterviewLists 	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from ProjectsPresentedLists         	where PeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from ProjectsSources				where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from ProjectsClientEmployeesLists   	where PeopleID IN( SELECT PeopleID FROM Deleted)

     	delete from ProjectsShortLists           		where PeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from ProjectsTargetLists          		where PeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from ProjectTargetCompaniesCandidates 	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from ProjectsFileSearchCandidates  	where PeopleID IN( SELECT PeopleID FROM Deleted)
	
	delete from JobOrdersTargetCompaniesCandidates		where PeopleID IN (SELECT PeopleID FROM Deleted)
	delete from JobOrdersSources					where PeopleID IN (SELECT PeopleID FROM Deleted)

     	delete from CandidateReferrals			where PeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from CandidateReferrals             	where SourcePeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from CandidateReferences            	where PeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from CandidateReferences            	where RefereePeopleID IN( SELECT PeopleID FROM Deleted)
     	delete from PeopleAppliedTo 				where PeopleID IN( SELECT PeopleID FROM Deleted)

     	delete from LinkContactsToTask		where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from CandidateCredentials		where CandidatePeopleID IN( SELECT PeopleID FROM Deleted)
	delete from Education				where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from EMailArchive   			where PeopleID IN( SELECT PeopleID FROM Deleted) AND CompaniesID IS NULL
	delete from LinkPeopleToPackage 		where PeopleID IN( SELECT PeopleID FROM Deleted)

	delete from PeopleAvailability		where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from LinkPeopleToRates			where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from LinkPeopleToCredentials 	where PeopleID IN( SELECT PeopleID FROM Deleted)
	delete from LinkPeopleToCompanies		where PeopleID IN( SELECT PeopleID FROM Deleted)

	update Assignments set PeopleID = NULL     		where PeopleID IN( SELECT PeopleID FROM Deleted)
	update Assignments set ContactPeopleID = NULL   	where ContactPeopleID IN( SELECT PeopleID FROM Deleted)
	update JobOrders set PlacedByPeopleID =  NULL 		where PlacedByPeopleID IN( SELECT PeopleID FROM Deleted)
	update JobOrders set InvoiceToPeopleID  = NULL 		where InvoiceToPeopleID IN( SELECT PeopleID FROM Deleted)
     	update JobOrders set LeadContactPeopleID  = NULL 	where LeadContactPeopleID IN( SELECT PeopleID FROM Deleted)
        	
	update JobOrders set ReportsToPeopleID  = NULL 		where ReportsToPeopleID IN( SELECT PeopleID FROM Deleted)
	update Projects set BillingToPeopleID =  NULL 		where BillingToPeopleID IN( SELECT PeopleID FROM Deleted)
end

GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrdersCompaniesLists]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrdersTargetCompaniesCandidates]  TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[JobOrdersSources]  TO [DeskFlowUsers]


