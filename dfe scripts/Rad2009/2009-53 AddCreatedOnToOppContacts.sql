ALTER TABLE LinkContactsToOpportunities add CreatedOn datetime default getdate(),
CreatedBy varchar(20) default suser_sname()