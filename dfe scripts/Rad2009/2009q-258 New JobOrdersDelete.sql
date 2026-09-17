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
AND People.PeopleID IS NULL

GO
