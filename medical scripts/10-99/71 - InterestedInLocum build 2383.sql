if (select max(updatedon) from OpportunityTypes) <'01/01/2011'
	begin
		delete from OpportunityTypes
		insert into OpportunityTypes (Name) values('Y')
		insert into OpportunityTypes (Name) values('N')
	end
GO
if (( select count(*) from LookupTables where Name='OpportunityTypes')=0)
	insert into LookupTables (Name,description,Editable,Visible) 
	values ('OpportunityTypes','Interested in Locums','Name','Name')
else
	update LookupTables set Description= 'Interested in Locums' where Name='OpportunityTypes'