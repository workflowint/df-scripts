ALTER TRIGGER ProjectStagesDelete ON [dbo].[ProjectStages]   
FOR DELETE   
AS  
----------------------------------------------------------------------------------------------------------- 
delete from LinkTaskToProjectStages  where ProjectStagesID IN(SELECT ProjectStagesID FROM deleted)

GO

ALTER  TRIGGER [dbo].[ProjectsSourcesOnDelete] ON [dbo].[ProjectsSources]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
UPDATE ProjectsCallStatus SET InclSO = NULL  
FROM Deleted,ProjectsCallStatus WHERE   
(ProjectsCallStatus.ProjectsID = Deleted.ProjectsID AND ProjectsCallStatus.PeopleID = Deleted.PeopleID)  


GO

ALTER TRIGGER [dbo].[ProjectsSourcesINSERT] ON [dbo].[ProjectsSources]   
FOR INSERT AS  
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN 
  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclSO)  
  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
 END  
 ELSE   
  UPDATE ProjectsCallStatus SET InclSO = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID
    END     
close  Row  
deallocate  Row  


GO

ALTER TRIGGER [dbo].[ProjectsShortListsOnDelete] ON [dbo].[ProjectsShortLists]  
FOR DELETE  
AS  
set nocount on
-----------------------------------------------------------------------------------------------------------  
declare @PeopleID               int  
declare @ProjectsID             int  
  
declare Row cursor local  for  
     select   
         PeopleID,  
         ProjectsID  
     from   
         deleted  
-----------------------------------------------------------------------------------------------------------  
  
open Row  
  
fetch next from Row into @PeopleID, @ProjectsID  
  
while @@fetch_status = 0  
    begin  
  
         delete Interview                    where PeopleID = @PeopleID AND ProjectsID = @ProjectsID and Done = 0
         delete CandidateCredentials where CandidatePeopleID = @PeopleID AND ProjectsID = @ProjectsID  
         delete CandidateReferences where PeopleID = @PeopleID AND ProjectsID = @ProjectsID  
   UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclCI = NULL  
    WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )   
     
   EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 11  
     
         fetch next from Row into @PeopleID, @ProjectsID  
  
    end  
            
close            Row  
deallocate  Row  
  


GO

ALTER TRIGGER [dbo].[ProjectsShortListsINSERT] ON [dbo].[ProjectsShortLists]   
FOR INSERT AS  
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN 
		EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclCI)  
		VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
	END  
	ELSE   
		UPDATE ProjectsCallStatus SET InclCI = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)   

	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 11  
	fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
END     
close  Row  
deallocate  Row  
  


GO

ALTER TRIGGER [dbo].[ProjectsPresentedListsINSERT] ON [dbo].[ProjectsPresentedLists]   
FOR INSERT AS   
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
		EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclPR)  
		VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
	END  
	ELSE   
		UPDATE ProjectsCallStatus SET InclPR = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  

	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 10
	fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
END     
close  Row  
deallocate  Row  
  


GO

ALTER TRIGGER [dbo].[ProjectsInternalInterviewListsINSERT] ON [dbo].[ProjectsInternalInterviewLists]   
FOR INSERT AS  
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
		EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclII)  
		VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
	END  
	ELSE   
		UPDATE ProjectsCallStatus SET InclII = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  

	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 9  
	fetch next from Row into @PeopleID, @ProjectsID, @PCSID
END     
close  Row  
deallocate  Row  
  


GO

ALTER TRIGGER [dbo].[ProjectsFileSearchCandidatesINSERT] ON [dbo].[ProjectsFileSearchCandidates]   
FOR INSERT AS  
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
		declare @ProjectsCallStatusID int  
		EXECUTE GetNewID 'ProjectsCallStatusID',@ProjectsCallStatusID OUTPUT   
		INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclFS)  
		VALUES(  @ProjectsCallStatusID, @PeopleID, @ProjectsID, 1 )  
	END  
	ELSE   
		UPDATE ProjectsCallStatus SET InclFS = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  

	EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 1  

	fetch next from Row into @PeopleID, @ProjectsID, @PCSID  
END     
close  Row  
deallocate  Row  


GO

ALTER TRIGGER ProjectsCompaniesListsDelete ON dbo.ProjectsCompaniesLists  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
delete ProjectTargetCompaniesCandidates
from ProjectTargetCompaniesCandidates, deleted
where ProjectTargetCompaniesCandidates.ProjectsID = deleted.ProjectsID and ProjectTargetCompaniesCandidates.CompaniesID = deleted.CompaniesID


GO

ALTER TRIGGER ProjectsClientTeamsOnDelete ON dbo.ProjectsClientTeams  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
delete L
from LinkInterviewersToClientInterview L
join deleted
	on L.LeftID = deleted.PeopleID
	AND L.RightID IN ( select InterviewID from Interview where ProjectsID = deleted.ProjectsID AND Done = 0 )

delete Interview
from Interview
join deleted
	on deleted.PeopleID = Interview.Interviewer
	AND deleted.ProjectsID = Interview.ProjectsID
	AND Interview.Done = 0


GO

ALTER TRIGGER [dbo].[ProjectsClientEmployeesListsINSERT] ON [dbo].[ProjectsClientEmployeesLists]   
FOR INSERT AS
set nocount on  
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN 
	IF @PCSID IS NULL BEGIN 
  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclIR)  
  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
 END  
 ELSE   
  UPDATE ProjectsCallStatus SET InclIR = 1  
	WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID) 
    
 EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 5  
   
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID
   
    END     
close  Row  
deallocate  Row  
  


GO

ALTER TRIGGER ProjectsCallStatusUpdateG ON dbo.ProjectsCallStatus
FOR UPDATE
AS
--remove PCS record if candidate has been removed from all project lists
IF UPDATE(InclFS) OR UPDATE(InclBM) OR UPDATE(InclTC) OR UPDATE(InclAR) OR UPDATE(InclIR) OR UPDATE(InclSO)
OR UPDATE(InclCR) OR UPDATE(InclII) OR UPDATE(InclPR) OR UPDATE(InclCI) OR UPDATE(InclSR) OR UPDATE(InclPL)
	DELETE PCS
	FROM ProjectsCallStatus PCS
	JOIN inserted
		ON inserted.ProjectsCallStatusID = PCS.ProjectsCallStatusID
	WHERE IsNull(inserted.InclFS,0) = 0 AND IsNull(inserted.InclBM,0) = 0 AND IsNull(inserted.InclTC,0) = 0 AND IsNull(inserted.InclAR,0) = 0
		AND IsNull(inserted.InclIR,0) = 0 AND IsNull(inserted.InclSO,0) = 0 AND IsNull(inserted.InclCR,0) = 0 AND IsNull(inserted.InclII,0) = 0
		AND IsNull(inserted.InclPR,0) = 0 AND IsNull(inserted.InclCI,0) = 0 AND IsNull(inserted.InclSR,0) = 0 AND ISNULL(inserted.InclPL,0) = 0

update ProjectsCallStatus set
             ProjectsCallStatus.UpdatedBy = suser_sname(),
             ProjectsCallStatus.UpdatedOn = getutcdate(),
             ProjectsCallStatus.UTCUpdatedOn = 1
FROM Inserted, ProjectsCallStatus
WHERE Inserted.ProjectsCallStatusID = ProjectsCallStatus.ProjectsCallStatusID


GO

ALTER  TRIGGER [dbo].[ProjectsBenchmarkCandidatesOnDelete] ON [dbo].[ProjectsBenchmarkCandidates]    
FOR DELETE    
AS    
-----------------------------------------------------------------------------------------------------------    
UPDATE ProjectsCallStatus SET InclBM = NULL    
FROM Deleted,ProjectsCallStatus WHERE     
(ProjectsCallStatus.ProjectsID = Deleted.ProjectsID AND ProjectsCallStatus.PeopleID = Deleted.PeopleID) 


GO

ALTER TRIGGER [dbo].[ProjectsBenchmarkCandidatesINSERT] ON [dbo].[ProjectsBenchmarkCandidates]   
FOR INSERT AS  
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
	select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
	from Inserted
	LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
	where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN 
	  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
	  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclBM)  
	  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
	END	
 ELSE   
  UPDATE ProjectsCallStatus SET InclBM = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID
    END     
close  Row  
deallocate  Row  


GO

ALTER TRIGGER [ProjectPlannerTemplatesDelete] ON dbo.ProjectPlannerTemplates   
FOR DELETE   
AS  
-----------------------------------------------------------------------------------------------------------  
delete from ProjectTemplateStages where TemplateID IN(SELECT ProjectPlannerTemplatesID FROM deleted)


GO

ALTER TRIGGER [dbo].[ProjectOnDelete] ON [dbo].[Projects]    
FOR DELETE    
AS    
-----------------------------------------------------------------------------------------------------------
delete ProjectsCallStatus where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectBillingDetails where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectInvoices where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsBenchmarkCandidates where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsClientEmployeesLists where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsClientTeams where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsCompaniesLists where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsFileSearchCandidates where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsInternalInterviewLists where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsPresentedLists where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsShortLists where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete CandidateReferrals where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsSources where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsTargetLists where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsTeam where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete PeopleAppliedTo where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete LinkMediaToProject where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectStages where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete JobRequirements where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete InternalInterviews where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete WebJobPostings where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete LinkOpportunitiesToBusinessObjects where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete LinkEventsToBusinessObjects where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsAccounting where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete LastProjectActivity where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectsCandidateBlocks where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete Affiliates where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete CandidateCredentials where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete InternalInterviews where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete Interview where ProjectsID IN(SELECT ProjectsID FROM deleted)
delete ProjectStages where ProjectsID IN(SELECT ProjectsID FROM deleted)

delete LinkObjectToActivityHistory where LeftID IN(SELECT ProjectsID FROM deleted) AND ObjectTableName = 'Projects'
delete LinkObjectToDocument where LeftID IN(SELECT ProjectsID FROM deleted) AND ObjectTableName = 'Projects'
delete LinkObjectToTask where LeftID IN(SELECT ProjectsID FROM deleted) AND ObjectTableName = 'Projects'

delete ListsDetails where RecordID IN(SELECT ProjectsID FROM deleted) AND ListID IN ( SELECT ListsID FROM Lists WHERE SourceTable = 'Projects')

update People SET CandidateBlockStatus = NULL, CandidateBlockProjectsID = NULL  
      WHERE CandidateBlockProjectsID IN(SELECT ProjectsID FROM deleted)
update Task SET ProjectsID = NULL where ProjectsID IN(SELECT ProjectsID FROM deleted)
update WebRequests SET ProjectsID = NULL where ProjectsID IN(SELECT ProjectsID FROM deleted)


GO

ALTER TRIGGER ProjectInvoiceUpdate ON [dbo].[ProjectInvoices]   
FOR UPDATE   
AS  
-----------------------------------------------------------------------------------------------------------
update ProjectInvoices set   
                UpdatedBy = suser_sname(),  
                UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
         where   
                ProjectInvoicesID IN(SELECT ProjectInvoicesID FROM inserted)


GO

/*--------------------------------------------------------------------------------------------------------  
    When a Project Invoice record is deleted, this deletes all records  
    linked to the deleted record.  
   --------------------------------------------------------------------------------------------------------*/  
ALTER TRIGGER ProjectInvoicesDelete ON dbo.ProjectInvoices  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
delete InvoiceItems where ProjectInvoicesID IN(SELECT ProjectInvoicesID FROM deleted)


GO

ALTER  TRIGGER [dbo].[PositionsUpdate] ON [dbo].[Positions]  
FOR UPDATE   
AS

--set UpdatedOn, UpdatedBy
UPDATE  Positions  
SET  Positions.UpdatedBy = suser_sname(),  
UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
FROM Inserted,  Positions  
WHERE Inserted.PositionsID =  Positions.PositionsID  

--update exchange rate if a money field has changed
UPDATE Positions  
SET    
ExchangeRate = (SELECT CurrentRate FROM ExchangeRates WITH(NOLOCK)  
	WHERE CurrencyUnit = Positions.CurrencyType),  
ExchangeRateDate = GETDATE()
FROM inserted
JOIN deleted
	ON deleted.PositionsID = inserted.PositionsID
JOIN Positions
	ON deleted.PositionsID = Positions.PositionsID
WHERE (deleted.CurrencyType <> inserted.CurrencyType  
OR deleted.BillRate <> inserted.BillRate  
OR deleted.Bonus <> inserted.Bonus  
OR deleted.BonusHigh <> inserted.BonusHigh  
OR deleted.Budget <> inserted.Budget  
OR deleted.CommissionOnCandidate <> inserted.CommissionOnCandidate  
OR deleted.CommissionOnClientOwner <> inserted.CommissionOnClientOwner  
OR deleted.CommissionOnExtOther <> inserted.CommissionOnExtOther  
OR deleted.CommissionOnFill <> inserted.CommissionOnFill  
OR deleted.CommissionOnIntOther <> inserted.CommissionOnIntOther  
OR deleted.CommissionOnPermOrder <> inserted.CommissionOnPermOrder  
OR deleted.CommissionTotal <> inserted.CommissionTotal  
OR deleted.FlatFee <> inserted.FlatFee  
OR deleted.PayRate <> inserted.PayRate  
OR deleted.Salary <> inserted.Salary  
OR deleted.TotalCompensation <> inserted.TotalCompensation  
OR deleted.TotalCompHigh <> inserted.TotalCompHigh  
)

--if a person was added to a project position, update their ProjectCallStatus for InclPL
UPDATE ProjectsCallStatus
SET InclPL = 1
FROM Inserted
JOIN deleted
	ON inserted.PositionsID = deleted.PositionsID
JOIN ProjectsCallStatus
	ON ProjectsCallStatus.ProjectsID = inserted.ProjectsID
	AND ProjectsCallStatus.PeopleID = inserted.PeopleID
WHERE inserted.PeopleID > 0
	AND inserted.PeopleID <> ISNULL(deleted.PeopleID, 0)

--if a person was removed from a project position, update their ProjectCallStatus for InclPL
UPDATE ProjectsCallStatus
SET InclPL = 0
FROM Inserted
JOIN deleted
	ON inserted.PositionsID = deleted.PositionsID
JOIN ProjectsCallStatus
	ON ProjectsCallStatus.ProjectsID = deleted.ProjectsID
	AND ProjectsCallStatus.PeopleID = deleted.PeopleID
WHERE deleted.PeopleID > 0
	AND deleted.PeopleID <> ISNULL(inserted.PeopleID, 0)


GO

ALTER TRIGGER [dbo].[PositionsINSERT] ON [dbo].[Positions]  
FOR INSERT   
AS  
BEGIN  
  
UPDATE ProjectsCallStatus SET InclPL = 1  
FROM Inserted,ProjectsCallStatus WHERE   
(ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND ProjectsCallStatus.PeopleID = Inserted.PeopleID AND inserted.ProjectsID > 0)  
  
UPDATE  Positions  
SET  Positions.CurrencyType = ClientConfig.MainCurrency,  
Positions.ExchangeRate =ExchangeRates.CurrentRate  
FROM Inserted,  Positions,ClientConfig WITH(NOLOCK) LEFT JOIN   
ExchangeRates WITH(NOLOCK) on ( ClientConfig.MainCurrency = ExchangeRates.CurrencyUnit)  
WHERE Inserted.PositionsID =  Positions.PositionsID  
and IsNull(Positions.CurrencyType,'')='' and ClientConfig.MainCurrency is not null  
  
  
END


GO

ALTER TRIGGER [dbo].[PositionsDelete] ON [dbo].[Positions]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
delete from PositionDetails where PositionsID IN(SELECT PositionsID FROM deleted)
delete from LinkPositionsToRates where PositionsID IN(SELECT PositionsID FROM deleted)
delete from LinkJobOrderScheduleToPosition where PositionsID IN(SELECT PositionsID FROM deleted)
delete from LinkJobOrderToWorksteps where PositionsID IN(SELECT PositionsID FROM deleted)
delete from TimeSheets where PositionsID IN(SELECT PositionsID FROM deleted)
delete from PositionExpenses where PositionsID IN(SELECT PositionsID FROM deleted)
delete from JobOrderPositionTeams where PositionsID IN(SELECT PositionsID FROM deleted)

update Task SET PositionsID = NULL where PositionsID IN(SELECT PositionsID FROM deleted)

UPDATE ProjectsCallStatus
SET InclPL = NULL
FROM deleted
WHERE deleted.ProjectsID > 0
AND deleted.ProjectsID = ProjectsCallStatus.ProjectsID
AND deleted.PeopleID = ProjectsCallStatus.PeopleID


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
   


GO

ALTER  TRIGGER [dbo].[PeopleAppliedToOnDelete] ON [dbo].[PeopleAppliedTo]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
UPDATE ProjectsCallStatus SET InclAR = NULL
FROM Deleted,ProjectsCallStatus WHERE
(ProjectsCallStatus.ProjectsID = Deleted.ProjectsID AND ProjectsCallStatus.PeopleID = Deleted.PeopleID)


GO

ALTER TRIGGER [dbo].[PeopleAppliedToINSERT] ON [dbo].[PeopleAppliedTo]   
FOR INSERT AS   
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
	  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
	  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclAR)  
	  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
	END  
	ELSE   
		UPDATE ProjectsCallStatus SET InclAR = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID
    END     
close  Row  
deallocate  Row  


GO

ALTER TRIGGER [OpportunitiesDelete] ON dbo.Opportunities   
FOR DELETE   
AS  
-----------------------------------------------------------------------------------------------------------
delete from OpportunityTeams where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)
delete from LinkContactsToOpportunities where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)
delete from LinkCompaniesToOpportunities where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)
delete from LinkEventsToBusinessObjects where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)
delete from LinkOpportunitiesToBusinessObjects where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)
delete from JobRequirements where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)

delete from LinkObjectToActivityHistory where LeftID IN(SELECT OpportunitiesID FROM deleted) and ObjectTableName = 'Opportunities'
delete from LinkObjectToDocument where LeftID IN(SELECT OpportunitiesID FROM deleted) and ObjectTableName = 'Opportunities'
delete from LinkObjectToTask where LeftID IN(SELECT OpportunitiesID FROM deleted) and ObjectTableName = 'Opportunities'

update Task set OpportunitiesID = NULL  where OpportunitiesID IN(SELECT OpportunitiesID FROM deleted)


GO

ALTER TRIGGER [dbo].[MProjectsDelete] ON [dbo].[MProjects]   
FOR DELETE   
AS
-----------------------------------------------------------------------------------------------------------  
DELETE FROM LinkCandidatesToMProjects WHERE MProjectsID IN(SELECT MProjectsID FROM deleted)
DELETE FROM LinkCandidatesToMPContacts WHERE MProjectsID IN(SELECT MProjectsID FROM deleted)
DELETE FROM LinkEventsToBusinessObjects WHERE MProjectsID IN(SELECT MProjectsID FROM deleted)
DELETE FROM LinkContactsToMProjects WHERE MProjectsID IN(SELECT MProjectsID FROM deleted)
DELETE FROM MProjectCompaniesLists WHERE MProjectsID IN(SELECT MProjectsID FROM deleted)

UPDATE LinkPeopleToCompanies SET MProjectsID = NULL WHERE MProjectsID IN(SELECT MProjectsID FROM deleted)
update Task set MProjectsID = NULL where MProjectsID IN(SELECT MProjectsID FROM deleted)

delete from LinkObjectToActivityHistory where LeftID IN(SELECT MProjectsID FROM deleted) and ObjectTableName = 'MProjects'
delete from LinkObjectToDocument where LeftID IN(SELECT MProjectsID FROM deleted) and ObjectTableName = 'MProjects'
delete LinkObjectToTask where LeftID IN(SELECT MProjectsID FROM deleted) AND ObjectTableName = 'MProjects'


GO

ALTER TRIGGER [dbo].[MProjectCompaniesListsDelete] ON [dbo].[MProjectCompaniesLists]  
FOR DELETE  
AS
DELETE MProjectCompaniesContacts
FROM deleted
WHERE MProjectCompaniesContacts.MProjectsID = deleted.MProjectsID
AND MProjectCompaniesContacts.CompaniesID = deleted.CompaniesID


GO

ALTER TRIGGER [LinkContactsToMProjectsOnDelete] ON [dbo].[LinkContactsToMProjects]   
FOR DELETE   
AS
--------------------------------------------------------------------------
DELETE LinkCandidatesToMPContacts
FROM LinkCandidatesToMPContacts
JOIN deleted
	ON deleted.MProjectsID = LinkCandidatesToMPContacts.MProjectsID
	AND deleted.PeopleID = LinkCandidatesToMPContacts.ContactPeopleID


GO

ALTER TRIGGER [LinkCandidatesToMPContactsOnDelete] ON [dbo].[LinkCandidatesToMPContacts]   
FOR DELETE   
AS
DELETE FROM Task WHERE TaskID IN(SELECT TaskID FROM deleted)


GO

ALTER TRIGGER JobOrdersDelete ON JobOrders
FOR DELETE  
AS
-----------------------------------------------------------------------------------------------------------
--delete contract invoices?
--delete internal interview?
--delete region coverage?
--delete WebApplications?
--delete WebRequests?
DELETE FROM Interview WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderConsideredPeople WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderPresentedPeople WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderInterviewPeople WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderInternalInterviewPeople WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM PeopleAppliedTo WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM CandidateReferrals WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM CandidateCredentials WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobRequirements WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM WebJobPostings WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM TimeSheets WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM Assignments WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM LinkJobOrdersToRates WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderSchedule WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderClientTeams WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrderTeams WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrdersCompaniesLists WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrdersSources WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM LinkJobOrderToWorksteps WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM LinkOpportunitiesToBusinessObjects WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM LinkEventsToBusinessObjects WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM JobOrdersConditions WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
DELETE FROM ProjectsCallStatus WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)

DELETE FROM LinkObjectToActivityHistory WHERE LeftID IN(SELECT JobOrdersID FROM deleted) AND ObjectTableName = 'JobOrders'
DELETE FROM LinkObjectToDocument WHERE LeftID IN(SELECT JobOrdersID FROM deleted) AND ObjectTableName = 'JobOrders'
DELETE FROM LinkObjectToTask WHERE LeftID IN(SELECT JobOrdersID FROM deleted) AND ObjectTableName = 'JobOrders'

DELETE FROM ListsDetails WHERE RecordID IN(SELECT JobOrdersID FROM deleted)
AND ListID IN( SELECT ListsID FROM Lists WHERE SourceTable IN('MRContracts', 'Temp', 'PermOrders', 'Contracts'))

UPDATE Task SET JobOrdersID = NULL WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)
UPDATE WebRequests SET JobOrdersID = NULL WHERE JobOrdersID IN(SELECT JobOrdersID FROM deleted)

DELETE Positions FROM Positions LEFT JOIN People ON People.PeopleID = Positions.PeopleID
WHERE Positions.JobOrdersID IN(SELECT JobOrdersID FROM deleted)
AND People.PeopleID IS NOT NULL


GO

ALTER TRIGGER JobOrdersCompaniesListsDelete ON JobOrdersCompaniesLists
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
DELETE JobOrdersTargetCompaniesCandidates
FROM JobOrdersTargetCompaniesCandidates
JOIN deleted
	ON deleted.JobOrdersID = JobOrdersTargetCompaniesCandidates.JobOrdersID
	AND deleted.CompaniesID = JobOrdersTargetCompaniesCandidates.CompaniesID


GO

ALTER TRIGGER InterviewOnDelete ON dbo.Interview  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------
DELETE FROM LinkInterviewersToClientInterview WHERE RightID IN(SELECT InterviewID FROM deleted)
DELETE FROM Task WHERE TaskID IN(SELECT TaskID FROM deleted) AND CallCode IS NULL


GO

ALTER TRIGGER InternalInterviewsDelete ON dbo.InternalInterviews  
FOR  DELETE   
AS  
-----------------------------------------------------------------------------------------------------------
DELETE FROM Task WHERE TaskID IN(SELECT TaskID FROM deleted) AND CallCode IS NULL
DELETE FROM LinkInternalInterviewsToResults WHERE InternalInterviewsID IN(SELECT InternalInterviewsID FROM deleted)
DELETE FROM LinkSkillsToInternalInterview WHERE InternalInterviewsID IN(SELECT InternalInterviewsID FROM deleted) 


GO

ALTER TRIGGER ExportToExcelDelete ON dbo.ExportToExcel  
FOR DELETE
AS
DELETE FROM ExportToExcelField WHERE ExportToExcelID IN(SELECT ExportToExcelID FROM deleted)


GO

ALTER TRIGGER ExportPackagesOnDelete ON dbo.ExportPackages  
FOR DELETE  
AS
DELETE FROM LinkPeopleToPackage WHERE PackageID IN(SELECT ExportPackagesID FROM deleted)
DELETE FROM LinkCompaniesToPackage WHERE PackageID IN(SELECT ExportPackagesID FROM deleted)


GO

ALTER TRIGGER EMailAddressUpdate ON dbo.EMailAddress  
FOR UPDATE  
AS  
-----------------------------------------------------------------------------------------------------------  
UPDATE EMailAddress SET UpdatedBy = SUSER_SNAME(), UpdatedOn = GETDATE()
WHERE EMailAddressID IN(SELECT EMailAddressID FROM inserted)


GO

ALTER TRIGGER DuplicatesDelete ON dbo.Duplicates  
FOR DELETE   
AS  
---------------------------------------------------------------------------------------------------
DELETE FROM DuplicatesEducation WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)
DELETE FROM DuplicatesSkills WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)
DELETE FROM LinkAnswersToDuplicates WHERE DuplicatesID IN(SELECT DuplicatesID FROM deleted)


GO

/*  
    When a DocumenCategoy record is deleted, this updates reference in Documents as well  
*/  
ALTER TRIGGER DocumentCategoriesDelete ON dbo.DocumentCategories  
FOR DELETE   
AS  
-------------------------------------------------------------------------------------------------------------------- 
UPDATE Document SET CategoriesID = NULL WHERE CategoriesID IN(SELECT DocumentCategoriesID FROM deleted)


GO

ALTER  TRIGGER DistributionListDeleteCleanUp ON dbo.EMailAddress   
FOR DELETE   
AS  
delete from LinkAddressToDistList
WHERE DistListID IN(SELECT EMailAddressID FROM deleted)
OR EMailAddressID IN(SELECT EMailAddressID FROM deleted)


GO

/*  
    When a Lists record is deleted, this deletes all ListDetail records linked  
    to the deleted record.  
*/  
ALTER TRIGGER DeleteLists ON [Lists]   
FOR DELETE   
AS  
--------------------------------------------------------------------------------------------------------------------  
DELETE FROM ListsDetails WHERE ListID IN(SELECT ListsID from deleted)


GO

/*  
   Deletes all records in child tables that are linked to the record, including records   
   in the SystemView table.  
*/  
ALTER TRIGGER DeleteLinks ON dbo.EMailArchive   
FOR DELETE   
AS  
-------------------------------------------------------------------------------------  
DELETE FROM EMailMsgRecipients WHERE EMailArchiveID IN(SELECT EMailArchiveID FROM deleted)
DELETE FROM EMailMsgAttachments WHERE EMailArchiveID IN(SELECT EMailArchiveID FROM deleted)
DELETE FROM LinkObjectToActivityHistory WHERE LeftID IN(SELECT EMailArchiveID FROM deleted) AND ObjectTableName = 'EmailArchive'


GO

ALTER TRIGGER ContractInvoicesDelete ON dbo.ContractInvoices  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
DELETE FROM ContractInvoiceItems WHERE ContractInvoicesID IN(SELECT ContractInvoicesID FROM deleted)


GO

ALTER TRIGGER ContractInvoiceItemsDelete ON dbo.ContractInvoiceItems  
FOR DELETE  
AS
-----------------------------------------------------------------------------------------------------------  
UPDATE TimeSheets SET DateProcessed = NULL, ContractInvoiceItemsID = NULL
WHERE ContractInvoiceItemsID IN(SELECT ContractInvoiceItemsID FROM deleted)

UPDATE AssignmentExpenses SET DateProcessed = NULL, ContractInvoiceItemsID = NULL
WHERE ContractInvoiceItemsID IN(SELECT ContractInvoiceItemsID FROM deleted)
-----------------------------------------------------------------------------------------------------------  


GO

/*--------------------------------------------------------------------------------------------------------  
    When a Companies record is deleted, this deletes all records  
    linked to the deleted record.  
   --------------------------------------------------------------------------------------------------------*/  
ALTER TRIGGER [dbo].[CompaniesDelete] ON [dbo].[Companies]  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
DELETE FROM Addresses WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM CompaniesIndustry WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM CompaniesAliases WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM LinkCompaniesToRates WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM EMailAddress WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM LinkCompaniesToAttributes WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM ClientContactTeams WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM LinkPeopleToCompanies WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM LinkCompaniesToOpportunities WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM ProjectsCompaniesLists WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM JobOrdersCompaniesLists WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM MProjectCompaniesLists WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM LinkCompaniesToPVA WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM Notes WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM CompaniesBlockByAddresses WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM CompaniesBlockByRoleCodes WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)
DELETE FROM CompaniesBlockBySkills WHERE CompaniesID IN(SELECT CompaniesID FROM deleted)

DELETE FROM LinkObjectToActivityHistory WHERE LeftID IN(SELECT CompaniesID FROM deleted) and ObjectTableName = 'Companies' 
DELETE FROM LinkObjectToDocument WHERE LeftID IN(SELECT CompaniesID FROM deleted) and ObjectTableName = 'Companies' 
DELETE FROM LinkObjectToTask WHERE LeftID IN(SELECT CompaniesID FROM deleted) and ObjectTableName = 'Companies' 

DELETE FROM LinkCompanyToCompanies WHERE CompaniesID IN(SELECT CompaniesID FROM deleted) OR LinkedCompaniesID IN(SELECT CompaniesID FROM deleted)

DELETE FROM ListsDetails  where RecordID IN( SELECT CompaniesID FROM Deleted)  
        AND ListID IN ( SELECT ListsID FROM Lists WHERE SourceTable = 'Companies')


GO

ALTER  TRIGGER [dbo].[CandidateReferralsOnDelete] ON [dbo].[CandidateReferrals]
FOR DELETE
AS
-----------------------------------------------------------------------------------------------------------
declare @PeopleID               int
declare @ProjectsID             int

declare Row cursor local  for
     select distinct deleted.PeopleID, deleted.ProjectsID
     from deleted
     LEFT JOIN CandidateReferrals
		ON CandidateReferrals.ProjectsID = deleted.ProjectsID
		AND CandidateReferrals.PeopleID = deleted.PeopleID
	WHERE CandidateReferrals.CandidateReferralsID IS NULL --exclude candidates who are still in the referrals list for the same project
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @PeopleID, @ProjectsID

while @@fetch_status = 0 begin
	UPDATE ProjectsCallStatus SET ProjectsCallStatus.InclSR = NULL
	WHERE ( ProjectsCallStatus.PeopleID = @PeopleID AND ProjectsCallStatus.ProjectsID = @ProjectsID )
	
	EXEC RemoveCandidateProjectBlock @ProjectsID, @PeopleID, 7
	
	fetch next from Row into @PeopleID, @ProjectsID
end
          
close            Row
deallocate  Row


GO

alter TRIGGER [dbo].[CandidateReferralsINSERT] ON [dbo].[CandidateReferrals]   
FOR INSERT AS 
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclSR)  
  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
 END  
 ELSE   
  UPDATE ProjectsCallStatus SET InclSR = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)    
   
 EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 7  
   
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID
    END     
close  Row  
deallocate  Row  
  


GO

ALTER TRIGGER AssignmentsDelete ON dbo.Assignments  
FOR DELETE  
AS
/*
Not sure if this trigger should also delete from these tables:
ContractInvoiceItems
WebRequests
AssignmentExpenses
TimeSheets
*/
DELETE FROM LinkJobOrderToWorksteps WHERE AssignmentsID IN (SELECT AssignmentsID FROM deleted)

DELETE FROM LinkObjectToActivityHistory WHERE LeftID IN(SELECT AssignmentsID FROM deleted) and ObjectTableName = 'Assignments' 
DELETE FROM LinkObjectToDocument WHERE LeftID IN(SELECT AssignmentsID FROM deleted) and ObjectTableName = 'Assignments' 


GO

ALTER TRIGGER WorkStepsDelete ON dbo.WorkSteps  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
delete from LinkJobOrderToWorksteps      where WorkStepsID IN(SELECT WorkStepsID FROM deleted)


GO

ALTER TRIGGER WebSitesOnDelete ON [dbo].[WebSites]   
FOR DELETE   
AS  
-------------------------------------------------------------------------------------------------------------------- 
delete from LinkWebPostingToWebSite  where WebSitesID IN(SELECT WebSitesID FROM deleted)


GO

ALTER TRIGGER WebJobPostingsDelete ON dbo.WebJobPostings   
FOR DELETE   
AS  
  
delete from Questions     where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted)  
delete from SkillsQuestions where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted)  
delete from LinkWebPostingToWebSite where WebJobPostingsID IN(SELECT WebJobPostingsID FROM deleted) 


GO

ALTER TRIGGER WebApplicationsDelete ON dbo.WebApplications   
  
FOR DELETE   
  
AS  
delete from Answers     where WebApplicationsID IN(SELECT WebApplicationsID FROM deleted)
delete from LinkWebApplicantsToSkills where WebApplicantsID IN(SELECT WebApplicationsID FROM deleted) 


GO

ALTER TRIGGER [dbo].[UserListOnDelete] ON [dbo].[UserList]
FOR DELETE
AS
UPDATE DataCashTables set UpdatedOn = getutcdate(), UTCUpdatedOn = 1
WHERE Name ='UserList'

delete from LinkUsersToWorkgroups             where LeftID IN(SELECT UserListID FROM deleted)  
delete from UserEMailSettings                        where LoginName IN(SELECT LoginName FROM deleted)
delete from Signatures                                    where LoginName IN(SELECT LoginName FROM deleted)
delete from LinkUserToMailBox             where UserID IN(SELECT UserListID FROM deleted)  
delete from LinkUserToMailBox             where MailBoxID IN(SELECT UserListID FROM deleted)
delete from LinkUsersToManager             where UserID IN(SELECT UserListID FROM deleted)  
delete from LinkUsersToManager             where ManagerID IN(SELECT UserListID FROM deleted)
delete from LinkUsersToResponsibilities             where UserID IN(SELECT UserListID FROM deleted)  
delete from UserLastTouch                            where LoginName IN(SELECT LoginName FROM deleted)
delete from UserNoArchiveEmails            where LoginName IN(SELECT LoginName FROM deleted)


GO

ALTER TRIGGER UpdateSkillsCategories ON dbo.SkillsCategories   
FOR UPDATE  
AS  
-----------------------------------------------------------------------------------------------------------  
UPDATE DataCashTables set UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
WHERE Name ='SkillsCategories'  

update SkillsCategories set   
    UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
where   
    SkillsCategoriesID IN(SELECT SkillsCategoriesID FROM inserted)


GO

ALTER TRIGGER UpdateSkillsAliases ON dbo.SkillsAliases   
FOR UPDATE  
AS  
-----------------------------------------------------------------------------------------------------------
UPDATE DataCashTables set UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
WHERE Name ='SkillsAliases' 

update SkillsAliases set   
    UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
where   
    SkillsAliasesID IN(SELECT SkillsAliasesID FROM inserted)


GO

ALTER TRIGGER UpdateRoleCodes ON dbo.[RoleCodes]  
FOR UPDATE  
AS
--------------------------------------------------------------------------------------------------------------------  
UPDATE DataCashTables set UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
WHERE Name ='RoleCodes'

update RoleCodes  
set UpdatedBy = suser_sname(),  
      UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
from  
      inserted, RoleCodes  
where  
     RoleCodes.RoleCode1 = inserted.RoleCode1 and RoleCodes.RoleCode2 = inserted.RoleCode2


GO

ALTER TRIGGER UpdateLists ON [Lists]   
FOR UPDATE  
AS
UPDATE Lists SET UpdatedBy = suser_sname(),  
                UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1
WHERE ListsID IN(SELECT ListsID FROM inserted)


GO

ALTER TRIGGER UpdateListFolders ON dbo.ListFolders   
FOR  UPDATE  
AS  
-----------------------------------------------------------------------------------------------------------  
UPDATE ListFolders SET UpdatedBy = SUSER_SNAME(), UpdatedOn = GETDATE()
WHERE ListFoldersID IN(SELECT ListFoldersID FROM inserted)


GO

/*--------------------------------------------------------------------------------------------------------  
    When a WorkGroups record is deleted, this deletes all records  
    from LinkUsersToWorkGroups in which the deleted record(s)  
    figure.  
   --------------------------------------------------------------------------------------------------------*/  
ALTER   TRIGGER UnLinkUsers ON dbo.WorkGroups   
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
delete LinkUsersToWorkGroups where RightID IN(SELECT WorkGroupsID FROM deleted) 
delete GroupPermissions where WorkGroupsID IN(SELECT WorkGroupsID FROM deleted)


GO

/*  
   Deletes all associated TaskData records.  
*/  
ALTER TRIGGER TaskDelete ON dbo.Task   
FOR  DELETE   
AS  
-----------------------------------------------------------------------------------------------------------
delete TaskData where TaskID IN(SELECT TaskID FROM deleted)  
delete LinkContactsToTask where TaskID IN(SELECT TaskID FROM deleted)  
delete LinkTaskToProjectStages where TaskID IN(SELECT TaskID FROM deleted)  
delete LinkObjectToTask where RightID IN(SELECT TaskID FROM deleted)  


GO

/*  
    When a Skills record is deleted, this deletes all records in various tables that   
    are linked to the deleted skill.  
*/  
ALTER TRIGGER SkillsDelete ON [Skills]   
FOR  DELETE   
AS  
--------------------------------------------------------------------------------------------------------------------
delete from LinkSkillsToSkillsCategories where LeftID  IN(SELECT SkillsID FROM deleted)
delete from LinkPeopleToSkills where SkillsID IN(SELECT SkillsID FROM deleted)
delete from JobRequirements where Type = 'Skill' AND Index2 IN(SELECT SkillsID FROM deleted)
delete from SkillsAliases where SkillsID IN(SELECT SkillsID FROM deleted)
delete from LinkCompaniesToAttributes where SkillsID IN(SELECT SkillsID FROM deleted)


GO

ALTER TRIGGER ResumeUpdate ON dbo.Resumes  
FOR UPDATE  
AS  
-----------------------------------------------------------------------------------------------------------
update Resumes set   
                UpdatedBy = suser_sname(),  
                UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
         where   
                ResumesID IN(SELECT ResumesID FROM inserted)


GO

ALTER TRIGGER ResearchersOnDelete ON dbo.Researchers  
FOR DELETE  
AS  
-----------------------------------------------------------------------------------------------------------  
delete ExportPackages where ResearchersID IN(SELECT ResearchersID FROM deleted)


GO

/*  
    When a Document record is deleted, this deletes all records in the  
    LinkOjectToDocument table in which the deleted record figures.  
*/  
ALTER TRIGGER RemoveDocumentLinks ON dbo.Document  
FOR DELETE   
AS  
-------------------------------------------------------------------------------------------------------------------- 
DELETE FROM LinkObjectToDocument WHERE RightID IN(SELECT DocumentID FROM deleted)
UPDATE Document SET ParentDocumentID = NULL WHERE ParentDocumentID IN(SELECT DocumentID FROM deleted)


GO

ALTER TRIGGER QuestionsOnDelete ON dbo.Questions  
FOR DELETE   
AS  
-----------------------------------------------------------------------------------------------------------
delete from MultipleAnswerItems where QuestionsID IN(SELECT QuestionsID FROM deleted)


GO

ALTER TRIGGER [ProjectTemplateStagesDelete] ON [dbo].[ProjectTemplateStages]   
FOR DELETE   
AS  
delete from ProjectTemplateTasks where StageID IN(select   ProjectTemplateStagesID from deleted  )



GO

ALTER TRIGGER [dbo].[ProjectTargetCompaniesCandidatesINSERT] ON [dbo].[ProjectTargetCompaniesCandidates]   
FOR INSERT AS  
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
	  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
	  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclTC)  
	  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
 END  
 ELSE   
  UPDATE ProjectsCallStatus SET InclTC = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  
      
 EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 3  
  
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
END     
close  Row  
deallocate  Row  
  


GO

ALTER TRIGGER ProjectsUpdate ON dbo.Projects
FOR UPDATE   
AS  

UPDATE  Projects  
SET  Projects.UpdatedBy = suser_sname(),  
UpdatedOn = GetUTCDate(), UTCUpdatedOn = 1  
FROM Inserted, Projects
WHERE Inserted.ProjectsID = Projects.ProjectsID
  
UPDATE Projects  
SET ExchangeRate = (SELECT CurrentRate FROM ExchangeRates WITH(NOLOCK)  
WHERE CurrencyUnit = Inserted.CurrencyType),  
ExchangeRateDate = GETDATE()
FROM Inserted
JOIN deleted
	ON deleted.ProjectsID = inserted.ProjectsID
JOIN Projects
	ON Inserted.ProjectsID = Projects.ProjectsID  
WHERE Inserted.CurrencyType <> deleted.CurrencyType  
OR Inserted.CustomCurrency1 <> deleted.CustomCurrency1  
OR Inserted.CustomCurrency2 <> deleted.CustomCurrency2  
OR Inserted.CustomCurrency3 <> deleted.CustomCurrency3  
OR Inserted.BaseSalary <> deleted.BaseSalary  
OR Inserted.InitBaseSalary <> deleted.InitBaseSalary  
OR Inserted.TargetCompensation <> deleted.TargetCompensation  
OR Inserted.CashCompensation <> deleted.CashCompensation


GO

ALTER TRIGGER [dbo].[ProjectsTargetListsINSERT] ON [dbo].[ProjectsTargetLists]   
FOR INSERT AS   
set nocount on
declare @PeopleID               int  
declare @ProjectsID             int  
declare @PCSID             int  
declare Row cursor local  for  
     select distinct inserted.PeopleID, inserted.ProjectsID, ProjectsCallStatus.ProjectsCallStatusID
     from Inserted
     LEFT JOIN ProjectsCallStatus
		ON ProjectsCallStatus.PeopleID = inserted.PeopleID
		AND ProjectsCallStatus.ProjectsID = inserted.ProjectsID
     where inserted.ProjectsID > 0  
open Row  
fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
WHILE @@fetch_status = 0 BEGIN
	IF @PCSID IS NULL BEGIN
  EXECUTE GetNewID 'ProjectsCallStatusID',@PCSID OUTPUT   
  INSERT INTO ProjectsCallStatus( ProjectsCallStatusID, PeopleID, ProjectsID, InclCR)  
  VALUES(  @PCSID, @PeopleID, @ProjectsID, 1 )  
 END  
 ELSE   
  UPDATE ProjectsCallStatus SET InclCR = 1  
		WHERE (ProjectsCallStatus.ProjectsCallStatusID = @PCSID)  
  
  EXEC AddCandidateProjectBlock @ProjectsID, @PeopleID, 8  
     
    fetch next from Row into @PeopleID, @ProjectsID, @PCSID 
    END     
close  Row  
deallocate  Row  
  


GO