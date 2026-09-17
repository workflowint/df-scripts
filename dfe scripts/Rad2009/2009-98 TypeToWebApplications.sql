if ( select count(*) from LookupTables where name='AffiliateRoles')=0
INSERT INTO LookupTables(Name,description,Editable,Visible,Candelete)
VALUES ('AffiliateRoles','Affiliate Roles','Description','Description',1)
GO
ALTER TABLE WebApplications add Type varchar(50)
GO
ALTER TABLE Duplicates add Type varchar(50)
GO
ALTER TABLE OfficeLocations add WebCandidateType varchar(50)
GO
UPDATE LookupTables set Editable='Description,WebCandidateType',Visible ='Name,Description,WebCandidateType'
where name='OfficeLocations'



