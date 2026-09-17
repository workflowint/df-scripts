alter table ClientConfig alter column MandatoryFieldsPeople varchar(max)
go
alter table ClientConfig alter column MandatoryFieldsCompanies varchar(max)
go
alter table ClientConfig alter column MandatoryFieldsProjects varchar(max)
go
alter table ClientConfig alter column MandatoryFieldsDirectHire varchar(max)
go
alter table ClientConfig alter column MandatoryFieldsContracts varchar(max)
go
alter table WebsiteJobBoards alter column WSJobBoardDescription varchar(max)
go
alter table WebsiteIndustryCodes alter column WSIndustryExtended varchar(max)
go
alter table Lists alter column SQL varchar(max)
go
alter table JobOrders alter column UserMemo1 varchar(max)
go
alter table JobOrders alter column UserMemo2 varchar(max)
go
alter table JobOrders alter column UserMemo3 varchar(max)
go
alter table JobOrders alter column UserMemo4 varchar(max)
go
alter table JobOrders alter column UserMemo5 varchar(max)
go
alter table LinkMediaToProject alter column AdDocument varchar(max)
go
alter table Companies alter column CustomMemo1 varchar(max)
go
alter table Companies alter column CustomMemo2 varchar(max)
go
alter table Projects alter column CustomMemo1 varchar(max)
go
alter table Projects alter column CustomMemo2 varchar(max)
go
alter table People alter column CustomMemo1 varchar(max)
go
alter table People alter column CustomMemo2 varchar(max)
go
alter table [Events] alter column Notes varchar(max)
go
alter table EventGroups alter column Comments varchar(max)
go
alter table SearchContactRecord alter column PreviousEmployment varchar(max)
go
alter table LinkPeopleToCredentials alter column Notes varchar(max)
go
alter table LinkPeopleToCompanies alter column Comments varchar(max)
go
alter table LinkCompaniesToPVA alter column Comments varchar(max)
go
alter table LinkPeopleToNetWork alter column Notes varchar(max)
go
alter table MProjects alter column ProjectNotes varchar(max)
go
alter table LinkContactsToMProjects alter column LinkNotes varchar(max)
go
alter table LinkCandidatesToMPContacts alter column IntroNotes varchar(max)
go
alter table CandidateCredentials alter column Notes varchar(max)
go
alter table PerformanceLogData alter column SQLStatement varchar(max)
go
alter table PerformanceLogData alter column SQLStatement varchar(max)
go
alter table PerformanceLogData alter column SQLStatement varchar(max)
go
alter table Positions alter column JobFunction varchar(max)
go
alter table ExportToExcel alter column SQL varchar(max)
go
alter table ExportToExcel alter column Fields varchar(max)
go
alter table UserExports alter column Import varchar(max)
go
alter table UserExports alter column RecordIDs varchar(max)
go
alter table ClientConfig alter column SCRText varchar(max)
go
alter table JobOrders alter column SCROriginalText varchar(max)
go
alter table Projects alter column SCROriginalText varchar(max)
go
alter table Assignments alter column Notes varchar(max)
go
alter table Assignments alter column PlacementComments varchar(max)
go
alter table Sticky alter column Message varchar(max)
go
alter table ProjectStages alter column StageTaskIDs varchar(max)
go
alter table ProjectStages alter column StageNotes varchar(max)
go
alter table PowerSearchTypes alter column LinkSQL varchar(max)
go
alter table PowerSearchItems alter column SQL varchar(max)
go
alter table PowerSearch alter column SearchData varchar(max)
go
alter table PowerSearch alter column AttributesData varchar(max)
go
alter table AnswerItems alter column TextValue varchar(max)
go
alter table Answers alter column Question varchar(max)
go
alter table Responces alter column Notes varchar(max)
go
alter table Templates alter column SQL varchar(max)
go
alter table UserLastTouch alter column PlannerUsers varchar(max)
go
alter table CandidateReferences alter column Notes varchar(max)
go
alter table MarketingCallReport alter column Notes varchar(max)
go
alter table Task alter column Details varchar(max)
go
alter table WebRequests alter column RequestNotes varchar(max)
go
alter table WebRequests alter column CompanyNotes varchar(max)
go
alter table WebRequests alter column CompanyIndustries varchar(max)
go
alter table Signatures alter column Signature varchar(max)
go
alter table SkillsQuestions alter column HTMLCode varchar(max)
go
alter table Questions alter column HTMLCode varchar(max)
go
alter table Duplicates alter column Answers varchar(max)
go
alter table CandidateReferrals alter column Notes varchar(max)
go
alter table JobOrders alter column Notes varchar(max)
go
alter table JobOrders alter column Notes varchar(max)
go
alter table JobOrders alter column Notes varchar(max)
go
alter table JobOrders alter column JobFunction varchar(max)
go
alter table JobOrders alter column BillingNotes varchar(max)
go
alter table InternalInterviews alter column Comments varchar(max)
go
alter table Interview alter column Notes varchar(max)
go
alter table Interview alter column ClientComments varchar(max)
go
alter table Interview alter column CandidateComments varchar(max)
go
alter table WebJobPostings alter column JobDescription varchar(max)
go
alter table WebJobPostings alter column AlertMessage varchar(max)
go
alter table LinkSkillsToInternalInterview alter column Notes varchar(max)
go
alter table SearchContactRecord alter column Comments varchar(max)
go
alter table Companies alter column Notes varchar(max)
go
alter table Companies alter column BlockNotes varchar(max)
go
alter table CompaniesBlock alter column BlockNotes varchar(max)
go
alter table Opportunities alter column Comments varchar(max)
go
alter table LinkClnInterviewsToResults alter column ShortResNotes varchar(max)
go
alter table Projects alter column Notes varchar(max)
go
alter table LinkInternalInterviewsToResults alter column ShortResNotes varchar(max)
go
alter table ResumeJinniConfig alter column SMTPNotifyMessage varchar(max)
go
alter table ResumeJinniConfig alter column SMTPConfirmationMessage varchar(max)
go
alter table Duplicates alter column ResumeTextImage varchar(max)
go
alter table Duplicates alter column Comments varchar(max)
go
alter table Duplicates alter column AHNotes varchar(max)
go
alter table WebSites alter column ErrorMessage varchar(max)
go
alter table WebSites alter column SuccessMessage varchar(max)
go
alter table WebApplications alter column AHNotes varchar(max)
go
alter table WebApplications alter column Comments varchar(max)
go
alter table EMailArchive alter column MsgBodyText varchar(max)
go
alter table EMailArchive alter column MsgBodyRTF varchar(max)
go
alter table EMailArchive alter column MsgBodyHTML varchar(max)
go
alter table People alter column FYINotes varchar(max)
go
alter table ProfileImporterEmployment alter column CompanyDetail varchar(max)
go
alter table ProfileImporterEmployment alter column Description varchar(max)
go
alter table ProfileImporterPeople alter column NoteText varchar(max)
go
alter table ProfileImporterPeople alter column Summary varchar(max)
go
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Answers_Answer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Answers] DROP CONSTRAINT [DF_Answers_Answer]
END
GO
alter table Answers alter column Answer varchar(max)
go






