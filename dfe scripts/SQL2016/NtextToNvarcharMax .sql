alter table ClientConfig alter column MandatoryFieldsPeople nvarchar(max)
go
alter table ClientConfig alter column MandatoryFieldsCompanies nvarchar(max)
go
alter table ClientConfig alter column MandatoryFieldsProjects nvarchar(max)
go
alter table ClientConfig alter column MandatoryFieldsDirectHire nvarchar(max)
go
alter table ClientConfig alter column MandatoryFieldsContracts nvarchar(max)
go
alter table WebsiteJobBoards alter column WSJobBoardDescription nvarchar(max)
go
alter table WebsiteIndustryCodes alter column WSIndustryExtended nvarchar(max)
go
alter table Lists alter column SQL nvarchar(max)
go
alter table JobOrders alter column UserMemo1 nvarchar(max)
go
alter table JobOrders alter column UserMemo2 nvarchar(max)
go
alter table JobOrders alter column UserMemo3 nvarchar(max)
go
alter table JobOrders alter column UserMemo4 nvarchar(max)
go
alter table JobOrders alter column UserMemo5 nvarchar(max)
go
alter table LinkMediaToProject alter column AdDocument nvarchar(max)
go
alter table Companies alter column CustomMemo1 nvarchar(max)
go
alter table Companies alter column CustomMemo2 nvarchar(max)
go
alter table Projects alter column CustomMemo1 nvarchar(max)
go
alter table Projects alter column CustomMemo2 nvarchar(max)
go
alter table People alter column CustomMemo1 nvarchar(max)
go
alter table People alter column CustomMemo2 nvarchar(max)
go
alter table [Events] alter column Notes nvarchar(max)
go
alter table EventGroups alter column Comments nvarchar(max)
go
alter table SearchContactRecord alter column PreviousEmployment nvarchar(max)
go
alter table LinkPeopleToCredentials alter column Notes nvarchar(max)
go
alter table LinkPeopleToCompanies alter column Comments nvarchar(max)
go
alter table LinkCompaniesToPVA alter column Comments nvarchar(max)
go
alter table LinkPeopleToNetWork alter column Notes nvarchar(max)
go
alter table MProjects alter column ProjectNotes nvarchar(max)
go
alter table LinkContactsToMProjects alter column LinkNotes nvarchar(max)
go
alter table LinkCandidatesToMPContacts alter column IntroNotes nvarchar(max)
go
alter table CandidateCredentials alter column Notes nvarchar(max)
go
alter table PerformanceLogData alter column SQLStatement nvarchar(max)
go
alter table PerformanceLogData alter column SQLStatement nvarchar(max)
go
alter table PerformanceLogData alter column SQLStatement nvarchar(max)
go
alter table Positions alter column JobFunction nvarchar(max)
go
alter table ExportToExcel alter column SQL nvarchar(max)
go
alter table ExportToExcel alter column Fields nvarchar(max)
go
alter table UserExports alter column Import nvarchar(max)
go
alter table UserExports alter column RecordIDs nvarchar(max)
go
alter table ClientConfig alter column SCRText nvarchar(max)
go
alter table JobOrders alter column SCROriginalText nvarchar(max)
go
alter table Projects alter column SCROriginalText nvarchar(max)
go
alter table Assignments alter column Notes nvarchar(max)
go
alter table Assignments alter column PlacementComments nvarchar(max)
go
alter table Sticky alter column Message nvarchar(max)
go
alter table ProjectStages alter column StageTaskIDs nvarchar(max)
go
alter table ProjectStages alter column StageNotes nvarchar(max)
go
alter table PowerSearchTypes alter column LinkSQL nvarchar(max)
go
alter table PowerSearchItems alter column SQL nvarchar(max)
go
alter table PowerSearch alter column SearchData nvarchar(max)
go
alter table PowerSearch alter column AttributesData nvarchar(max)
go
alter table AnswerItems alter column TextValue nvarchar(max)
go
alter table Answers alter column Question nvarchar(max)
go
alter table Responces alter column Notes nvarchar(max)
go
alter table Templates alter column SQL nvarchar(max)
go
alter table UserLastTouch alter column PlannerUsers nvarchar(max)
go
alter table CandidateReferences alter column Notes nvarchar(max)
go
alter table MarketingCallReport alter column Notes nvarchar(max)
go
alter table Task alter column Details nvarchar(max)
go
alter table WebRequests alter column RequestNotes nvarchar(max)
go
alter table WebRequests alter column CompanyNotes nvarchar(max)
go
alter table WebRequests alter column CompanyIndustries nvarchar(max)
go
alter table Signatures alter column Signature nvarchar(max)
go
alter table SkillsQuestions alter column HTMLCode nvarchar(max)
go
alter table Questions alter column HTMLCode nvarchar(max)
go
alter table Duplicates alter column Answers nvarchar(max)
go
alter table CandidateReferrals alter column Notes nvarchar(max)
go
alter table JobOrders alter column Notes nvarchar(max)
go
alter table JobOrders alter column Notes nvarchar(max)
go
alter table JobOrders alter column Notes nvarchar(max)
go
alter table JobOrders alter column JobFunction nvarchar(max)
go
alter table JobOrders alter column BillingNotes nvarchar(max)
go
alter table InternalInterviews alter column Comments nvarchar(max)
go
alter table Interview alter column Notes nvarchar(max)
go
alter table Interview alter column ClientComments nvarchar(max)
go
alter table Interview alter column CandidateComments nvarchar(max)
go
alter table WebJobPostings alter column JobDescription nvarchar(max)
go
alter table WebJobPostings alter column AlertMessage nvarchar(max)
go
alter table LinkSkillsToInternalInterview alter column Notes nvarchar(max)
go
alter table SearchContactRecord alter column Comments nvarchar(max)
go
alter table Companies alter column Notes nvarchar(max)
go
alter table Companies alter column BlockNotes nvarchar(max)
go
alter table CompaniesBlock alter column BlockNotes nvarchar(max)
go
alter table Opportunities alter column Comments nvarchar(max)
go
alter table LinkClnInterviewsToResults alter column ShortResNotes nvarchar(max)
go
alter table Projects alter column Notes nvarchar(max)
go
alter table LinkInternalInterviewsToResults alter column ShortResNotes nvarchar(max)
go
alter table ResumeJinniConfig alter column SMTPNotifyMessage nvarchar(max)
go
alter table ResumeJinniConfig alter column SMTPConfirmationMessage nvarchar(max)
go
alter table Duplicates alter column ResumeTextImage nvarchar(max)
go
alter table Duplicates alter column Comments nvarchar(max)
go
alter table Duplicates alter column AHNotes nvarchar(max)
go
alter table WebSites alter column ErrorMessage nvarchar(max)
go
alter table WebSites alter column SuccessMessage nvarchar(max)
go
alter table WebApplications alter column AHNotes nvarchar(max)
go
alter table WebApplications alter column Comments nvarchar(max)
go
alter table EMailArchive alter column MsgBodyText nvarchar(max)
go
alter table EMailArchive alter column MsgBodyRTF nvarchar(max)
go
alter table EMailArchive alter column MsgBodyHTML nvarchar(max)
go
alter table People alter column FYINotes nvarchar(max)
go
alter table ProfileImporterEmployment alter column CompanyDetail nvarchar(max)
go
alter table ProfileImporterEmployment alter column Description nvarchar(max)
go
alter table ProfileImporterPeople alter column NoteText nvarchar(max)
go
alter table ProfileImporterPeople alter column Summary nvarchar(max)
go
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Answers_Answer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Answers] DROP CONSTRAINT [DF_Answers_Answer]