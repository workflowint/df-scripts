ALTER TABLE OpportunityTeams add Split float
GO
ALTER TABLE LinkCompaniesToOpportunities add 
CreatedOn datetime NULL default getutcdate(),
CreatedBy varchar(20) NULL default suser_sname()
