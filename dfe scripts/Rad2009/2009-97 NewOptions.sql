ALTER TABLE Positions add AssistantGender char(1)
GO
ALTER TABLE Opportunities add OppPracticeID int
GO
ALTER TABLE GroupPermissions add CreateProjectFromOpportunity bit
GO
UPDATE GroupPermissions set CreateProjectFromOpportunity=0
GO
ALTER TABLE ClientConfig add IntIntResultsMandatory bit
GO
ALTER TABLE People add SpouseID int
GO
ALTER TRIGGER [dbo].[CustomFormDataTrigger] ON [dbo].[CustomFormData] 
FOR INSERT, UPDATE, DELETE 
AS
UPDATE  CustomFormData SET  CustomFormData.UpdatedBy = suser_sname(),
UpdatedOn = GETDATE()
FROM Inserted,  CustomFormData
WHERE Inserted.CustomFormDataID =  CustomFormData.CustomFormDataID

UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='CustomFormData'
