ALTER TABLE LinkPeopleToCompanies	ADD CONSTRAINT  DF_LinkPeopleToCompanies_UpdatedOn  DEFAULT (getdate()) for UpdatedOn
ALTER TABLE LinkPeopleToCompanies	ADD CONSTRAINT  DF_LinkPeopleToCompanies_UpdatedBy  DEFAULT (suser_sname()) for UpdatedBY
GO
ALTER TABLE LinkPeopleToCompanies add MProjectsID int
GO
ALTER TRIGGER [dbo].[MProjectsDelete] ON [dbo].[MProjects] 
FOR DELETE 
AS
-----------------------------------------------------------------------------------------------------------
declare @MProjectsID         int

declare Row cursor local  for
     select   MProjectsID
     from 
         deleted
-----------------------------------------------------------------------------------------------------------

open Row

fetch next from Row into @MProjectsID

while @@fetch_status = 0
    begin

        delete from LinkObjectToActivityHistory	where LeftID = @MProjectsID and ObjectTableName = 'MProjects'
        delete from LinkObjectToDocument	where LeftID = @MProjectsID and ObjectTableName = 'MProjects'
		update Task set MProjectsID = NULL	where MProjectsID = @MProjectsID
		delete from LinkCandidatesToMProjects	where MProjectsID = @MProjectsID
		delete from LinkCandidatesToMPContacts where MProjectsID = @MProjectsID
        delete from LinkEventsToBusinessObjects where MProjectsID = @MProjectsID
		delete from LinkContactsToMProjects	where MProjectsID = @MProjectsID
		delete from MProjectCompaniesLists where MProjectsID = @MProjectsID
		delete from LinkPeopleToCompanies where MProjectsID = @MProjectsID
    
		fetch next from Row into @MProjectsID

    end
          
close Row
deallocate  Row


