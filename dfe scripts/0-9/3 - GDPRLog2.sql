/****** Object:  Table [dbo].[GDPRLog]    Script Date: 03/29/2018 09:46:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[GDPRLog](
	[GDPRLogID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleID] [int] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](60) NULL,
	[Phone1] [varchar](255) NULL,
	[Phone2] [varchar](255) NULL,
	[Phone3] [varchar](255) NULL,
	[Phone4] [varchar](255) NULL,
	[Phone5] [varchar](255) NULL,
	[EmailAddress] [varchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[RestoreDate] [datetime] NULL,
	[RestoreUser] [varchar](20) NULL,
	[NewPeopleID] [int] NULL,
 CONSTRAINT [PK_GDPRLog] PRIMARY KEY CLUSTERED 
(
	[GDPRLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[GDPRLog] ADD  CONSTRAINT [DF_GDPRLog_CreatedOn]  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[GDPRLog] ADD  CONSTRAINT [DF_GDPRLog_CreatedBy]  DEFAULT (suser_sname()) FOR [CreatedBy]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[GDPRLog]  TO [DeskFlowUsers]
GO

/*--------------------------------------------------------------------------------------------------------   
 When a People record is deleted, this deletes all records   
 linked to the deleted record.   
 --------------------------------------------------------------------------------------------------------*/   
ALTER TRIGGER [dbo].[PeopleDelete] ON [dbo].[People]   
FOR DELETE   
AS   
-----------------------------------------------------------------------------------------------------------   
begin   
 
 --delete internal interview?
 --profile importer tables?
 --ResumeProcessing?
 if ( (select COUNT(*) from ClientConfig where GDPRSupport =1 ) > 0 )
 begin
	IF (SELECT COUNT(*) FROM deleted where IsNull(PermissiontoRetainData,0)=0 and PermissiontoRetainDate >'01/01/2017') > 0 
		BEGIN 
		INSERT INTO GDPRLog ( PeopleID,FirstName, LastName, Phone1,Phone2,Phone3,Phone4,Phone5,EmailAddress )
		SELECT PeopleID, FirstName, LastName, Phone1,Phone2,Phone3,Phone4,Phone5,dbo.fn_GetAllEmails(deleted.PeopleID) 
		from deleted where IsNull(PermissiontoRetainData,0)=0 and PermissiontoRetainDate >'01/01/1920'
	 END 
 end
 delete from Addresses where AddressesID IN (SELECT HomeAddressesID from Deleted)   
 delete from Addresses where AddressesID IN (SELECT BusinessAddressesID from Deleted)   
 delete from Addresses where AddressesID IN (SELECT AlternativeAddressesID from Deleted)   
   
 delete from Resumes  where PeopleID IN( SELECT PeopleID FROM Deleted)  
 delete from EMailAddress where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from Notes   where PeopleID IN( SELECT PeopleID FROM Deleted)  
   
 delete from LinkObjectToActivityHistory where LeftID IN( SELECT PeopleID FROM Deleted) and ObjectTableName = 'People'   
 delete from LinkObjectToDocument   where LeftID IN( SELECT PeopleID FROM Deleted) and ObjectTableName = 'People'    
 delete from LinkObjectToTask   where LeftID IN( SELECT PeopleID FROM Deleted) and ObjectTableName = 'People'   
 delete from LinkPeopleToNetWork   where LeftID IN( SELECT PeopleID FROM Deleted)   
 delete from LinkPeopleToNetWork   where RightID IN( SELECT PeopleID FROM Deleted)  
   
 delete from LinkPeopleToSkills  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ListsDetails   where RecordID IN( SELECT PeopleID FROM Deleted)   
         AND ListID IN ( SELECT ListsID FROM Lists WHERE SourceTable = 'People')   
   
 delete from JobOrderConsideredPeople   where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from JobOrderInterviewPeople   where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from JobOrderInternalInterviewPeople where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from JobOrderPresentedPeople   where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsClientTeams    where PeopleID IN( SELECT PeopleID FROM Deleted)   
   
 delete from ProjectsBenchmarkCandidates  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsInternalInterviewLists  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsPresentedLists    where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsSources     where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsClientEmployeesLists  where PeopleID IN( SELECT PeopleID FROM Deleted)   
   
 delete from ProjectsShortLists     where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsTargetLists    where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectTargetCompaniesCandidates where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsFileSearchCandidates  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 
 delete from Affiliates where PeopleID IN( SELECT PeopleID FROM Deleted)
 delete from CandidateCredentials where CandidatePeopleID IN( SELECT PeopleID FROM Deleted)
 
 delete from JobOrdersTargetCompaniesCandidates where PeopleID IN (SELECT PeopleID FROM Deleted)   
 delete from JobOrdersSources     where PeopleID IN (SELECT PeopleID FROM Deleted)   
   
 delete from CandidateReferrals  where PeopleID IN( SELECT PeopleID FROM Deleted) or SourcePeopleID IN( SELECT PeopleID FROM Deleted)
 delete from CandidateReferences where PeopleID IN( SELECT PeopleID FROM Deleted) or RefereePeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from PeopleAppliedTo  where PeopleID IN( SELECT PeopleID FROM Deleted)   
   
 delete from LinkContactsToTask  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from CandidateCredentials where CandidatePeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from Education    where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from EMailArchive   where PeopleID IN( SELECT PeopleID FROM Deleted) AND CompaniesID IS NULL   
 delete from LinkPeopleToPackage where PeopleID IN( SELECT PeopleID FROM Deleted)   
   
 delete from PeopleAvailability   where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from LinkPeopleToRates   where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from LinkPeopleToCredentials where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from LinkPeopleToCompanies  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from LastProjectActivity  where PeopleID IN( SELECT PeopleID FROM Deleted)   
 delete from ProjectsCandidateBlocks where PeopleID IN( SELECT PeopleID FROM Deleted)  
 
 delete from EventSessionsInvitees where PeopleID IN( SELECT PeopleID FROM Deleted)  
 delete from EventSessionVendors where PeopleID IN( SELECT PeopleID FROM Deleted)  
 delete from JobOrderClientTeams where PeopleID IN( SELECT PeopleID FROM Deleted)  
 delete from LinkCandidatesToMPContacts where CandPeopleID IN( SELECT PeopleID FROM Deleted)   or ContactPeopleID IN( SELECT PeopleID FROM Deleted)  
 delete from LinkCandidatesToMProjects where PeopleID IN( SELECT PeopleID FROM Deleted)  
 delete from LinkContactsToMProjects where PeopleID IN( SELECT PeopleID FROM Deleted)    
 
 delete from LinkContactsToOpportunities where PeopleID IN( SELECT PeopleID FROM Deleted)    
 delete from LinkPeopleToKnownToUsers where PeopleID IN( SELECT PeopleID FROM Deleted)    
 delete from MProjectCompaniesContacts where PeopleID IN( SELECT PeopleID FROM Deleted)    
 delete from PeopleAdditionalNames where PeopleID IN( SELECT PeopleID FROM Deleted)    
 delete from ProjectsCallStatus where PeopleID IN( SELECT PeopleID FROM Deleted)     
  
 update Assignments set PeopleID = NULL    where PeopleID IN( SELECT PeopleID FROM Deleted)   
 update Assignments set ContactPeopleID = NULL  where ContactPeopleID IN( SELECT PeopleID FROM Deleted)   
 update JobOrders set PlacedByPeopleID = NULL  where PlacedByPeopleID IN( SELECT PeopleID FROM Deleted)   
 update JobOrders set InvoiceToPeopleID = NULL  where InvoiceToPeopleID IN( SELECT PeopleID FROM Deleted)   
 update JobOrders set LeadContactPeopleID = NULL where LeadContactPeopleID IN( SELECT PeopleID FROM Deleted)   
   
 update JobOrders set ReportsToPeopleID = NULL  where ReportsToPeopleID IN( SELECT PeopleID FROM Deleted)   
 update Projects set BillingToPeopleID = NULL  where BillingToPeopleID IN( SELECT PeopleID FROM Deleted)   
 
 
 delete Positions 
 FROM Positions
 LEFT JOIN Projects
	ON Projects.ProjectsID = Positions.ProjectsID
 LEFT JOIN Joborders
	ON JobOrders.JobOrdersID = Positions.JobOrdersID
 where Positions.PeopleID IN( SELECT PeopleID FROM Deleted)  
 AND Projects.ProjectsID IS NULL
 AND JobOrders.JobOrdersID IS NULL
 
end   




