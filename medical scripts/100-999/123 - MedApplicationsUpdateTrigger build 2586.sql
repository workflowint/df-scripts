CREATE TRIGGER [dbo].[MedApplicationsUpdate] ON [dbo].[MedApplications] 
FOR UPDATE
NOT FOR REPLICATION
AS
UPDATE MedApplications
SET MedApplications.UpdatedBy = suser_sname(),
UpdatedOn = getutcdate(), UTCUpdatedOn=1 
FROM Inserted, MedApplications
WHERE Inserted.MedApplicationsID =MedApplications.MedApplicationsID
